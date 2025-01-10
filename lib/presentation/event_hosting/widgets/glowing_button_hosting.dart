// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:phuong_for_organizer/core/constants/color.dart';

class GlowingButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const GlowingButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  _GlowingButtonState createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _glowAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<BoxShadow> _generateGlowingShadow(double animationValue) {
    const double radius = 1;
    const double speedFactor = 0.9 / radius;
    List<Offset> shadowOffsets = [];
    
    // Adjust animation value by speed factor
    double adjustedValue = animationValue * speedFactor;
    
    // Calculate shadow positions with adjusted speed
    
    // Create trailing effect with adjusted speed
    // Increased number of shadows for smoother gradient
    const int numberOfShadows = 4;
    for (double i = 0; i < 0.8; i += 0.8 / numberOfShadows) {
      double trailX = radius * math.cos(adjustedValue - (i * speedFactor));
      double trailY = radius * math.sin(adjustedValue - (i * speedFactor));
      shadowOffsets.add(Offset(trailX, trailY));
    }

    // Create gradient colors
    final List<Color> gradientColors = [
    purple,  // Start color
    white,
       purple,
       white,   // Middle color
      purple,    // End color
    ];

    return List.generate(shadowOffsets.length, (index) {
      // Calculate color interpolation
      double colorPosition = index / shadowOffsets.length;
      Color shadowColor;
      
      if (colorPosition <= 0.5) {
        // Interpolate between first and second color
        shadowColor = Color.lerp(
          gradientColors[0],
          gradientColors[1],
          colorPosition * 2,
        )!;
      } else {
        // Interpolate between second and third color
        shadowColor = Color.lerp(
          gradientColors[1],
          gradientColors[2],
          (colorPosition - 0.5) * 2,
        )!;
      }

      return BoxShadow(
        color: shadowColor.withOpacity(0.3),
        blurRadius: 2,
        spreadRadius: 1,
        offset: shadowOffsets[index],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.8 > 430 ? 430.0 : screenWidth * 0.4;

    return Center(
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: _generateGlowingShadow(_glowAnimation.value),
            ),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) {
                setState(() => _isPressed = false);
                widget.onPressed();
              },
              onTapCancel: () => setState(() => _isPressed = false),
              child: Container(
                width: buttonWidth,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black,
                  border: Border.all(
                    color: purple.withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: _isPressed ? 5 : 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Example usage
class HomePagec extends StatelessWidget {
  const HomePagec({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: GlowingButton(
          text: 'Set Live',
          onPressed: () {
            print('Set Live');
          },
        ),
      ),
    );
  }
}