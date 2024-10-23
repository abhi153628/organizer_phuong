// lib/screens/admin/dashboard/widgets/stat_cards.dart


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatCards extends StatelessWidget {
  const StatCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard('Total Bands', '156', Icons.music_note, Colors.blue),
        const SizedBox(width: 24),
        _buildStatCard(
            'Pending Approvals', '23', Icons.pending_actions, Colors.orange),
        const SizedBox(width: 24),
        _buildStatCard('Rejected Events', '8', Icons.event, Colors.green),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
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
            Column(
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
          ],
        ),
      ),
    );
  }
}