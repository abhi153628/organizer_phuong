import 'package:flutter/material.dart';

import 'package:testing/view/dashboard_screen/accepted_screen.dart';

import 'package:testing/view/dashboard_screen/rejected_bands.dart';
import 'package:testing/view/dashboard_screen/widgets/welcoming_widget.dart';
import 'package:testing/view/dashboard_screen/widgets/firebase_service_fetching_band.dart';

//! SIDE BAR FUNCTIONS ON PRESSED
class DashboardContent extends StatelessWidget {
  final int selectedIndex;
  final int totalBands;
  final int pendingApprovals;
  final int rejectedBands;

  const DashboardContent({
    super.key,
    required this.selectedIndex,
    required this.totalBands,
    required this.pendingApprovals,
    required this.rejectedBands, required int rejectedEvents,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(),
            SizedBox(height: 40),
          
          
            FireBaseFetchingBand(),
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
    return const AcceptedBandsPage();
  }

  Widget _buildRejectedContent() {
    return const RejectedBandsPage();
  }


  Widget _buildDashboardContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardHeader(),
        SizedBox(height: 40),
       
        FireBaseFetchingBand(),
      ],
    );
  }
}
