import 'package:flutter/material.dart';
import 'package:testing/modal/model.dart';

class ImmersiveScrollingImages extends StatefulWidget {
  final int startingIndex;
  final int direction;

  const ImmersiveScrollingImages({
    Key? key,
    required this.startingIndex,
    required this.direction,
  }) : super(key: key);

  @override
  State<ImmersiveScrollingImages> createState() => _ImmersiveScrollingImagesState();
}

class _ImmersiveScrollingImagesState extends State<ImmersiveScrollingImages> {
  late ScrollController _scrollController;
  final _imageHeight = 600.0;
  final _totalImages = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    final totalHeight = _imageHeight * _totalImages;
    final scrollDuration = Duration(seconds: 90 + widget.startingIndex);

    _scrollController.animateTo(
      widget.direction > 0 ? totalHeight : 0,
      duration: scrollDuration,
      curve: Curves.linear,
    ).then((_) {
      if (mounted) {
        _scrollController.jumpTo(widget.direction > 0 ? 0 : totalHeight);
        _startScrolling();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateY(0.0), // slight rotation for 3D effect
      alignment: Alignment.center,
      child: Container(
        width: 450,
        height: 1000,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
            
              blurRadius: 10,
              spreadRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: ListView.builder(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _totalImages,
            itemBuilder: (context, index) {
              return Container(
                height: _imageHeight,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(modelsImages[(index + widget.startingIndex) % modelsImages.length]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}