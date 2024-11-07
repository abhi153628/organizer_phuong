import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//! WELCOMING
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust font sizes based on screen width
        double titleFontSize = constraints.maxWidth > 600 ? 28 : 22;
        double subtitleFontSize = constraints.maxWidth > 600 ? 16 : 14;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, Admin',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFFF5E1D),
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Here's what's happening with your platform today",
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: subtitleFontSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
