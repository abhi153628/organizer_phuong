import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';

class CustomSnackBar {
  static void show(BuildContext context, String message, Color backgroundColor ) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.white, // Icon color
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // Text color
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating, // Makes it float above UI
      backgroundColor: backgroundColor, // Eye-catching modern color
      elevation: 8, // Slightly higher elevation for a standout look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Smooth rounded corners
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Position and spacing
      duration: const Duration(seconds: 3), // Auto-dismiss duration
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: Colors.white,
        onPressed: () {
          // Optional dismiss action
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
