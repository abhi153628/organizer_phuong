// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:testing/res/image_string.dart';

//! AUTO SCROLLING IMAGE WIDGET IN THE RIGHT SIDE
class ScrollingImages extends StatefulWidget {
  final int startingIndex;

  const ScrollingImages({
    super.key,
    required this.startingIndex,
  });

  @override
  State<ScrollingImages> createState() => _ScrollingImagesState();
}

class _ScrollingImagesState extends State<ScrollingImages>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 20 + widget.startingIndex + 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.repeat();
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Transform.rotate(
          angle: 8.00 * pi,
          child: SizedBox(
            height: h * 0.999, //changing the total height of the moving images
            width: w * 0.19,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Stack(
                  children: List.generate(5, (index) {
                    final imageIndex =
                        (index + widget.startingIndex) % modelsImages.length;
                    return Positioned(
                      top: _calculatePosition(index, h * 0.6),
                      left: 2,
                      right: 5,
                      height: h * 0.6,
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(22)),
                              image: DecorationImage(
                                image: AssetImage(modelsImages[imageIndex]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
        // Vignette effect on top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: h * 0.1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Vignette effect on bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: h * 0.1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _calculatePosition(int index, double itemHeight) {
    final listHeight = itemHeight * 5;
    final offset = _animation.value * listHeight;
    final adjustedOffset = (offset + index * itemHeight) % listHeight;
    return adjustedOffset - itemHeight;
  }
}
