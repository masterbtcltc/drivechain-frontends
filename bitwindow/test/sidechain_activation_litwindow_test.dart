import 'package:bitwindow/litwindow_liteverse.dart';
import 'package:bitwindow/pages/sidechain_activation_management_page.dart';
import 'package:bitwindow/pages/sidechain_proposal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sail_ui/sail_ui.dart';

Widget _testApp(Widget child) {
  return MaterialApp(
    home: SailTheme(
      data: SailThemeData.lightTheme(
        SailColorScheme.orange,
        true,
        SailFontValues.inter,
      ),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('Liteverse slot 1 active state is read-only and non-crashing', (tester) async {
    await tester.pumpWidget(
      _testApp(
        const LitWindowSidechainActivationStatusCard(
          slotActive: true,
          pendingProposalCount: 0,
        ),
      ),
    );

    expect(find.text(litWindowSidechainActiveMessage), findsOneWidget);
    expect(find.text('Slot 1 Active'), findsWidgets);
    expect(find.text('Propose New Sidechain'), findsNothing);
    expect(find.text('Propose Sidechain'), findsNothing);
  });

  testWidgets('direct proposal view is disabled for LitWindow', (tester) async {
    await tester.pumpWidget(
      _testApp(const LitWindowSidechainProposalUnavailableView()),
    );

    expect(find.text(litWindowSidechainActiveMessage), findsOneWidget);
    expect(find.textContaining('never signs, broadcasts, or proposes'), findsOneWidget);
    expect(find.text('Propose Sidechain'), findsNothing);
  });
}
