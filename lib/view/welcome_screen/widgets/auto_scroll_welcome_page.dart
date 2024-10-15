import 'dart:math';
import 'package:flutter/material.dart';

import 'package:testing/modal/model.dart';


class ScrollingImages extends StatefulWidget {
  final int startingIndex;
  const ScrollingImages({
    super.key,
    required this.startingIndex,
  });

  @override
  State<ScrollingImages> createState() => _ScrollingImagesState();
}

class _ScrollingImagesState extends State<ScrollingImages> with SingleTickerProviderStateMixin {
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

    return Transform.rotate(
      angle: 8.00 * pi,
      child: SizedBox(
        height: h * 0.9,
        width: w * 0.19,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: List.generate(5, (index) {
                final imageIndex = (index + widget.startingIndex) % modelsImages.length;
                return Positioned(
                  top: _calculatePosition(index, h * 0.6),
                  left: 2,
                  right: 5,
                  height: h * 0.6,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(22)),
                      image: DecorationImage(
                        image: AssetImage(modelsImages[imageIndex]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  double _calculatePosition(int index, double itemHeight) {
    final listHeight = itemHeight * 5;
    final offset = _animation.value * listHeight;
    final adjustedOffset = (offset + index * itemHeight) % listHeight;
    return adjustedOffset - itemHeight;
  }
}