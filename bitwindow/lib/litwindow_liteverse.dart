import 'package:bitwindow/providers/sidechain_provider.dart';
import 'package:sail_ui/gen/drivechain/v1/drivechain.pb.dart';

const int liteverseEvmSlot = 1;
const String liteverseEvmName = 'LiteverseEVM';
const List<int> litWindowPrimarySidechainSlots = [liteverseEvmSlot];

const String litWindowSidechainActiveMessage =
    'LiteverseEVM slot 1 is already active on this local Litecoin signet stack.';
const String litWindowSidechainProposalUnavailableMessage =
    'Sidechain proposals are disabled in LitWindow. Use the guarded Liteverse local-devnet operator scripts for slot-1 rebuilds.';

bool isLitWindowPrimarySidechainSlot(int slot) => slot == liteverseEvmSlot;

List<SidechainOverview?> litWindowVisibleActiveSidechains(List<SidechainOverview?> sidechains) {
  return [
    for (final sidechain in sidechains)
      if (sidechain != null && isLitWindowPrimarySidechainSlot(sidechain.info.slot)) sidechain,
  ];
}

List<SidechainProposal> litWindowVisibleSidechainProposals(List<SidechainProposal> proposals) {
  return [
    for (final proposal in proposals)
      if (isLitWindowPrimarySidechainSlot(proposal.slot)) proposal,
  ];
}
