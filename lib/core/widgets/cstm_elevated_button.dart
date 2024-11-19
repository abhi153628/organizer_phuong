import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomElevatedButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final VoidCallback onPressed;
  final Color ?color;

  const CustomElevatedButton({
    super.key,
    this.icon,
    required this.text,
    required this.onPressed,
     this.color,

  });

  @override
  Widget build(BuildContext context) {
    double fontSize = 16;
    double responsiveFontSize = fontSize;

    // Responsive font size adjustments based on screen width
    if (MediaQuery.of(context).size.width < 360) {
      responsiveFontSize = fontSize * 0.85; // Small phones
    } else if (MediaQuery.of(context).size.width < 480) {
      responsiveFontSize = fontSize * 0.9; // Medium phones
    } else if (MediaQuery.of(context).size.width < 720) {
      responsiveFontSize = fontSize; // Large phones and tablets
    } else if (MediaQuery.of(context).size.width < 1080) {
      responsiveFontSize = fontSize * 1.1; // Small desktop screens
    } else {
      responsiveFontSize = fontSize * 1.2; // Large desktop screens
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: icon != null ? Colors.white : Colors.white24,
        foregroundColor: icon != null ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          
        ),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: responsiveFontSize),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: GoogleFonts.aBeeZee(
                    fontSize: responsiveFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Text(
              text,
              style: GoogleFonts.aBeeZee(
                fontSize: responsiveFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
