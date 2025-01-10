// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math' as math;

class SelectingTypeWidget extends StatefulWidget {
  final Function(int?) onSelectionChanged;

  const SelectingTypeWidget({Key? key, required this.onSelectionChanged}) : super(key: key);

  @override
  _SelectingTypeWidgetState createState() => _SelectingTypeWidgetState();
}

class _SelectingTypeWidgetState extends State<SelectingTypeWidget> {
  int? selectedIndex;

  final List<ArtistTy> languages = [
    ArtistTy('  Soloists', Colors.purple.withOpacity(0.4)),
    ArtistTy('Ensemble', Colors.red.withOpacity(0.8)),
  ];
  final List<String> imageList = [
    'asset/welcomepage_asset/image-from-rawpixel-id-13443971-jpeg-removebg-preview.png',
    'asset/welcomepage_asset/—Pngtree—live band_14120250.png'
  ];
  final List<Map<String, double>> imageSizes = [
    {'width': 340, 'height': 70},
    {'width': 200, 'height': 140},
  ];
  final List<Map<String, double>> imageTranslation = [
    {'x': 18.5, 'y': 27},
    {'x': 20, 'y': 14}
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    // Calculate scaling factor based on screen width
    final double scaleFactor = screenSize.width / 375; // Using 375 as base width

    return GridView.builder(
      padding: EdgeInsets.all(16 * scaleFactor),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16 * scaleFactor,
        mainAxisSpacing: 16 * scaleFactor,
      ),
      itemCount: languages.length,
      itemBuilder: (context, index) {
        return ContainerFrid(
          image: imageList[index],
          language: languages[index],
          isSelected: selectedIndex == index,
          onTap: () {
            setState(() {
              selectedIndex = selectedIndex == index ? null : index;
            });
            widget.onSelectionChanged(selectedIndex);
          },
          imageWidth: imageSizes[index]['width']! * scaleFactor,
          imageHeight: imageSizes[index]['height']! * scaleFactor,
          translateX: imageTranslation[index]['x']! * scaleFactor,
          translateY: imageTranslation[index]['y']! * scaleFactor,
          scaleFactor: scaleFactor,
        );
      },
    );
  }
}

class ContainerFrid extends StatefulWidget {
  final ArtistTy language;
  final bool isSelected;
  final VoidCallback onTap;
  final String image;
  final double imageHeight;
  final double imageWidth;
  final double translateX;
  final double translateY;
  final double scaleFactor;

  const ContainerFrid({
    Key? key,
    required this.language,
    required this.isSelected,
    required this.onTap,
    required this.image,
    required this.imageHeight,
    required this.imageWidth,
    required this.translateX,
    required this.translateY,
    required this.scaleFactor,
  }) : super(key: key);

  @override
  _ContainerFridState createState() => _ContainerFridState();
}

class _ContainerFridState extends State<ContainerFrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
  }

  @override
  void didUpdateWidget(ContainerFrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: widget.language.color,
                borderRadius: BorderRadius.circular(16 * widget.scaleFactor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1 * _scaleAnimation.value),
                    blurRadius: 10 * _scaleAnimation.value * widget.scaleFactor,
                    spreadRadius: 2 * _scaleAnimation.value * widget.scaleFactor,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  SizedBox(
                    width: widget.imageWidth,
                    height: widget.imageHeight,
                    child: Transform.scale(
                      scale: 1.2,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi)
                          ..translate(widget.translateX, widget.translateY),
                        child: Image.asset(
                          widget.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 68 * widget.scaleFactor,
                    top: 8 * widget.scaleFactor,
                    child: Text(
                      widget.language.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18 * widget.scaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10 * widget.scaleFactor,
                    top: 70 * widget.scaleFactor,
                    child: CustomCheckbox(
                      value: widget.isSelected,
                      onChanged: (bool? newValue) {
                        widget.onTap();
                      },
                      scaleFactor: widget.scaleFactor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final double scaleFactor;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.scaleFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20 * scaleFactor,
      height: 20 * scaleFactor,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        fillColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return Colors.transparent;
          },
        ),
        checkColor: Colors.black,
        side: BorderSide(color: Colors.white, width: 1 * scaleFactor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4 * scaleFactor),
        ),
      ),
    );
  }
}

class ArtistTy {
  final String name;
  final Color color;

  ArtistTy(this.name, this.color);
}