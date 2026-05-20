import 'package:bitwindow/providers/fast_withdrawal_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FastWithdrawalProvider.supportedLayer2Chains', () {
    test('exposes LiteverseEVM only for LitWindow', () {
      expect(FastWithdrawalProvider.supportedLayer2Chains, ['LiteverseEVM']);
      expect(FastWithdrawalProvider().layer2Chain, 'LiteverseEVM');
    });

    test('does not expose upstream Bitcoin sidechains', () {
      final list = FastWithdrawalProvider.supportedLayer2Chains;
      for (final chain in ['Thunder', 'BitNames', 'BitAssets', 'ZSide', 'Photon', 'Truthcoin', 'CoinShift']) {
        expect(list, isNot(contains(chain)));
      }
    });
  });
}
