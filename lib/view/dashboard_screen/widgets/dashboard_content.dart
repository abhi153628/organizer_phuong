import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/view/dashboard_screen/accepted_screen.dart';
import 'package:testing/view/dashboard_screen/dash_board.dart';
import 'package:testing/view/dashboard_screen/rejected_bands.dart';
import 'package:testing/view/dashboard_screen/widgets/dashboard_content_widget.dart';
import 'package:testing/view/dashboard_screen/widgets/pending_bands.dart';
import 'package:testing/view/dashboard_screen/widgets/stats_card.dart';

class DashboardContent extends StatelessWidget {
  final int selectedIndex;

  const DashboardContent({
    Key? key,
    required this.selectedIndex,
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
            const StatCards(),
            const SizedBox(height: 40),
            const PendingBands(),
          ],
        );
      case 1:
        return _buildApprovedContent();
      case 2:
        return _buildRejectedContent();
      case 3:
        return _buildPendingContent();
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardHeader(),
        SizedBox(height: 40),
        StatCards(),
        SizedBox(height: 40),
        PendingBands(),
      ],
    );
  }
}