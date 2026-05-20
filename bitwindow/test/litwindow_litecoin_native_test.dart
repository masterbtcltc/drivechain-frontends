import 'package:bitwindow/litwindow_liteverse.dart';
import 'package:bitwindow/providers/sidechain_provider.dart';
import 'package:bitwindow/pages/wallet/wallet_send.dart';
import 'package:bitwindow/utils/bitcoin_uri.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sail_ui/gen/drivechain/v1/drivechain.pb.dart';
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

  test('LitWindow activation lists only LiteverseEVM slot 1', () {
    final sidechains = List<SidechainOverview?>.filled(256, null);
    sidechains[1] = SidechainOverview(
      ListSidechainsResponse_Sidechain(slot: 1, title: 'LiteverseEVM'),
      [],
      [],
    );
    sidechains[73] = SidechainOverview(
      ListSidechainsResponse_Sidechain(slot: 73, title: 'Legacy Liteverse baseline'),
      [],
      [],
    );
    for (final bitcoinDefaultSlot in [2, 4, 9, 13, 98, 99]) {
      sidechains[bitcoinDefaultSlot] = SidechainOverview(
        ListSidechainsResponse_Sidechain(slot: bitcoinDefaultSlot, title: 'Bitcoin slot $bitcoinDefaultSlot'),
        [],
        [],
      );
    }

    final visibleSidechains = litWindowVisibleActiveSidechains(sidechains);
    expect(visibleSidechains.map((sidechain) => sidechain?.info.slot), [1]);

    final visibleProposals = litWindowVisibleSidechainProposals([
      SidechainProposal(slot: 1),
      SidechainProposal(slot: 2),
      SidechainProposal(slot: 73),
      SidechainProposal(slot: 99),
    ]);
    expect(visibleProposals.map((proposal) => proposal.slot), [1]);
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
