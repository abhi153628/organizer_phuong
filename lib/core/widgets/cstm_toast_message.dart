import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';

class CustomToast {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 200, // Adjust position as needed
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: red)),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Adjust text color if needed
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the toast after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
