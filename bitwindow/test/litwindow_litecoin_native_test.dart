import 'package:bitwindow/pages/sidechains_page.dart';
import 'package:bitwindow/pages/wallet/wallet_send.dart';
import 'package:bitwindow/utils/bitcoin_uri.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sail_ui/config/sidechain_main.dart';

void main() {
  test('LitWindow primary sidechain list is LiteverseEVM slot 1 only', () {
    expect(litWindowPrimarySidechainSlots, [1]);
    expect(sidechainBinaries, isEmpty);

    for (final bitcoinDefaultSlot in [2, 4, 9, 13, 73, 98, 99]) {
      expect(
        isLitWindowPrimarySidechainSlot(bitcoinDefaultSlot),
        isFalse,
        reason: 'slot $bitcoinDefaultSlot must not be a default LitWindow sidechain',
      );
    }
  });

  test('Litecoin recipient validation accepts tLTC and rejects Bitcoin prefixes', () {
    expect(
      isSupportedLitecoinRecipientInput('tltc1qexampleexampleexampleexampleexampleexample'),
      isTrue,
    );
    expect(
      isSupportedLitecoinRecipientInput('litecoin:tltc1qexampleexampleexampleexampleexampleexample?amount=1.23'),
      isTrue,
    );
    expect(
      isSupportedLitecoinRecipientInput('signetcash:tltc1qexampleexampleexampleexampleexampleexample?amount=1.23'),
      isTrue,
    );

    expect(isSupportedLitecoinRecipientInput('bc1qexampleexampleexampleexampleexample'), isFalse);
    expect(isSupportedLitecoinRecipientInput('tb1qexampleexampleexampleexampleexample'), isFalse);
    expect(isSupportedLitecoinRecipientInput('bcrt1qexampleexampleexampleexampleexample'), isFalse);
    expect(isSupportedLitecoinRecipientInput('1BoatSLRHtKNngkdXEeobR76b53LETtpyT'), isFalse);
    expect(isSupportedLitecoinRecipientInput('not-an-address'), isFalse);
  });

  test('Litecoin URI parser accepts Litecoin schemes and rejects bitcoin scheme', () {
    final uri = BitcoinURI.parse('litecoin:tltc1qexampleexampleexampleexampleexampleexample?amount=1.5&label=Test');

    expect(uri.address, 'tltc1qexampleexampleexampleexampleexampleexample');
    expect(uri.amount, 1.5);
    expect(uri.label, 'Test');

    expect(() => BitcoinURI.parse('bitcoin:bc1qexample'), throwsFormatException);
  });
}
