import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//! TOTAL BAND , PENDI\DING APPROVAL , REJECTED EVENTS RESPONSIVE CARDS
class StatCards extends StatelessWidget {
  final int totalBands;
  final int pendingApprovals;
  final int rejectedEvents;

  const StatCards({
    Key? key,
    required this.totalBands,
    required this.pendingApprovals,
    required this.rejectedEvents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600; // Adjust based on screen width

        return isWide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildStatCardList(),
              )
            : Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: _buildStatCardList(),
              );
      },
    );
  }

  List<Widget> _buildStatCardList() {
    return [
      _buildStatCard('Total Bands', totalBands.toString(), Icons.music_note, Colors.blue),
      _buildStatCard('Pending Approvals', pendingApprovals.toString(), Icons.pending_actions, Colors.orange),
      _buildStatCard('Rejected Events', rejectedEvents.toString(), Icons.event, Colors.green),
    ];
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(minWidth: 150, maxWidth: 200),
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
