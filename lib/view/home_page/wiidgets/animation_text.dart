import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
//! ANIMATED GRADIENT TEXT
class AnimatedGradientText extends StatefulWidget {
  final String text;
  final double fontSize;

  const AnimatedGradientText({
    Key? key,
    required this.text,
    this.fontSize = 115,
  }) : super(key: key);

  @override
  _AnimatedGradientTextState createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15), // Slower, consistent animation speed
      vsync: this,
    )..repeat(); // Continuously looping animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 26, 64, 105),
                Color.fromARGB(255, 247, 58, 58),
                Color.fromARGB(255, 34, 215, 255),
              ],
              stops: [
                (_controller.value - 0.2).clamp(0.0, 1.0),
                (_controller.value).clamp(0.0, 1.0),
                (_controller.value + 0.2).clamp(0.0, 1.0),
                (_controller.value + 0.4).clamp(0.0, 1.0),
              ],
              tileMode: TileMode.repeated, // Repeated flow for smooth animation
            ).createShader(bounds);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.text,
              style: GoogleFonts.montserrat(
                fontSize: getResponsiveFontSize(context, 3.3),
                color: Colors.white, // Base color of the text (if needed)
                fontWeight: FontWeight.w700,
                height: 1,
                letterSpacing: -0.5,
              ),
            ),
          ),
        );
      },
    );
  }
  double getResponsiveFontSize(BuildContext context, double scaleFactor) {
  double screenWidth = MediaQuery.of(context).size.width;
  // Adjust font scaling factor based on screen width
  if (screenWidth > 1200) {
    return 24 * scaleFactor; // Large screens, like desktops
  } else if (screenWidth > 800) {
    return 20 * scaleFactor; // Medium screens, like tablets
  } else {
    return 16 * scaleFactor; // Small screens, like mobile
  }
}

}
