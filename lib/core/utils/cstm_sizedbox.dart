import 'package:flutter/material.dart';

class CstmSizedBox extends StatelessWidget {
  final double widthFactor;
  final double heightFactor;

  const CstmSizedBox({
    Key? key,
    this.widthFactor = 0.0, // Default width factor (50% of screen width)
    this.heightFactor = 0.1, // Default height factor (30% of screen height)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * widthFactor,
      height: screenHeight * heightFactor,
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
