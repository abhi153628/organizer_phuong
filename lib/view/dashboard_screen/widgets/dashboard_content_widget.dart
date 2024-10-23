import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//!This is the page that show the top of page "'Welcome back, Admin'" and "'Here's what's happening with your platform today'"

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, Admin',
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 160, 25, 25),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "'Here's what's happening with your platform today'",
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
