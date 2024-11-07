import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/view/dashboard_screen/accepted_screen.dart';
import 'package:testing/view/dashboard_screen/dash_board.dart';
import 'package:testing/view/dashboard_screen/rejected_bands.dart';
import 'package:testing/view/dashboard_screen/widgets/welcoming_widget.dart';
import 'package:testing/view/dashboard_screen/widgets/firebase_service_fetching_band.dart';
import 'package:testing/view/dashboard_screen/widgets/stats_card.dart';
//! SIDE BAR FUNCTIONS ON PRESSED
class DashboardContent extends StatelessWidget {
  final int selectedIndex;
  final int totalBands;
  final int pendingApprovals;
  final int rejectedBands;

  const DashboardContent({
    Key? key,
    required this.selectedIndex,
    required this.totalBands,
    required this.pendingApprovals,
    required this.rejectedBands, required int rejectedEvents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeader(),
            const SizedBox(height: 40),
          
          
            const FireBaseFetchingBand(),
          ],
        );
      case 1:
        return _buildApprovedContent();
      case 2:
        return _buildRejectedContent();
      case 3:
        return _buildDashboardContent();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildApprovedContent() {
    return AcceptedBandsPage();
  }

  Widget _buildRejectedContent() {
    return RejectedBandsPage();
  }

  Widget _buildPendingContent() {
    return PhuongAdminDashboard();
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardHeader(),
        const SizedBox(height: 40),
       
        const FireBaseFetchingBand(),
      ],
    );
  }
}
