import 'package:bitwindow/pages/liteverse_bridge_status_panel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('LiteverseBridgeStatus ignores legacy slots and requires slot 1 data', () {
    final status = LiteverseBridgeStatus.fromOpsState({
      'ok': true,
      'generatedAt': '2026-05-19T00:00:00.000Z',
      'config': {
        'sidechainId': 73,
      },
      'issues': [],
      'litecoin': {
        'ok': true,
        'value': {
          'chain': 'signet',
          'blocks': 2015,
        },
      },
      'evm': {
        'ok': true,
        'value': {
          'blockNumber': 64387,
          'peerCount': 3,
          'bridgeAddress': '0xb90f5bb563d5d80f0af24c54713535908991e9a8',
        },
      },
      'enforcer': {
        'ok': true,
        'value': {
          'ping': 'Pong',
          'configuredSidechainId': 73,
          'activeSidechains': [
            {
              'proposal': {'sidechain_number': 73},
            },
          ],
          'ctipBySidechain': {
            '73': {
              'ok': true,
              'value': {
                'outpoint': '96fce684e7a800d90a6bff42846935d72d38a4cf60b80edaef9a8cdf76361c73:0',
                'value': 23400,
              },
            },
          },
          'recentEvents': {
            'ok': true,
            'value': {
              'deposits': [],
              'withdrawals': [],
              'bmm': [],
            },
          },
        },
      },
      'relayer': {
        'stateExists': false,
      },
    });

    expect(status.litecoinChain, 'signet');
    expect(status.litecoinHeight, 2015);
    expect(status.detectedSlot, 73);
    expect(status.isCanonicalSlotActive, isFalse);
    expect(status.activeSlots, isEmpty);
    expect(status.activeSlotsLabel, 'not available');
    expect(status.enforcerHealthyLabel, 'Pong');
    expect(status.besuHealthyLabel, 'healthy');
    expect(status.opsHealthyLabel, 'healthy');
    expect(status.ctipSidechain, isNull);
    expect(status.ctipValueSats, isNull);
    expect(status.ctipValueLabel, 'Slot 1 data unavailable');
    expect(status.bmmStatusLabel, 'no recent BMM events');
    expect(status.relayerStateLabel, 'state file not present');
  });

  test('LiteverseBridgeStatus renders canonical slot 1 only', () {
    final status = LiteverseBridgeStatus.fromOpsState({
      'ok': true,
      'config': {
        'sidechainId': 1,
      },
      'issues': [],
      'litecoin': {
        'ok': true,
        'value': {
          'chain': 'signet',
          'blocks': 2058,
        },
      },
      'evm': {
        'ok': true,
        'value': {
          'blockNumber': 86912,
          'peerCount': 3,
          'bridgeAddress': '0x512958b290f86e82f544af7f3f2684244bca7516',
        },
      },
      'enforcer': {
        'ok': true,
        'value': {
          'ping': 'Pong',
          'configuredSidechainId': 1,
          'activeSidechains': [
            {
              'proposal': {'sidechain_number': 1},
            },
            {
              'proposal': {'sidechain_number': 73},
            },
          ],
          'ctipBySidechain': {
            '1': {
              'ok': true,
              'value': {
                'outpoint': '553de56aa2dac53751ca19c2aecec9b2273046df9aad28d025ef40b3c5ab7b08:0',
                'value': 8600,
              },
            },
            '73': {
              'ok': true,
              'value': {
                'outpoint': '96fce684e7a800d90a6bff42846935d72d38a4cf60b80edaef9a8cdf76361c73:0',
                'value': 23400,
              },
            },
          },
          'recentEvents': {
            'ok': true,
            'value': {
              'deposits': [],
              'withdrawals': [],
              'bmm': [],
            },
          },
        },
      },
      'relayer': {
        'stateExists': true,
      },
    });

    expect(status.detectedSlot, 1);
    expect(status.isCanonicalSlotActive, isTrue);
    expect(status.activeSlots, [1]);
    expect(status.activeSlotsLabel, '1');
    expect(status.ctipSidechain, 1);
    expect(status.ctipValueSats, 8600);
  });
}
