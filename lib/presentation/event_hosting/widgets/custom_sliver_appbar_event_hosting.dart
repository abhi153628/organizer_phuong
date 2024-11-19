import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';

class CustomSliverAppBar extends StatelessWidget {
  final double scrollProgress;
  final String title;
  final Color scaffoldColor;
  final VoidCallback onIconPressed;

  const CustomSliverAppBar({
    Key? key,
    required this.scrollProgress,
    required this.title,
    required this.scaffoldColor,
    required this.onIconPressed,
  })  : assert(scrollProgress >= 0.0 && scrollProgress <= 2.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBarColorTween = ColorTween(
      begin: purple,
      end: purple.withOpacity(0.9),
    );

    final titleColorTween = ColorTween(
      begin: Colors.white,
      end: Colors.white.withOpacity(0.9),
    );

    return SliverAppBar(
      expandedHeight: 170.0,
      floating: false,
      pinned: true,
      elevation: 8,
      backgroundColor: Colors.transparent,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double appBarHeight = constraints.biggest.height;
          final double minAppBarHeight = kToolbarHeight;
          final double maxAppBarHeight = 120.0;

          final double collapsePercentage =
              ((maxAppBarHeight - appBarHeight) / (maxAppBarHeight - minAppBarHeight)).clamp(0.0, 1.0);

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  appBarColorTween.evaluate(AlwaysStoppedAnimation(collapsePercentage)) ?? purple,
                  scaffoldColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: scaffoldColor.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 120,
                  bottom: 40 + (constraints.maxHeight - minAppBarHeight) * (0.29 - collapsePercentage),
                  child: Text(
                    title,
                    style: GoogleFonts.lato(
                      color: titleColorTween.evaluate(AlwaysStoppedAnimation(collapsePercentage)),
                      fontSize: 20 + 4 * (1 - collapsePercentage),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 100 + (constraints.maxHeight - minAppBarHeight) * (0.24 - collapsePercentage),
                  child: Text(
                    "Make your profile shine to snag that admin seal of approval!",
                    style: GoogleFonts.aBeeZee(
                      color: titleColorTween.evaluate(AlwaysStoppedAnimation(collapsePercentage)),
                      fontSize: 9 + 2 * (1 - collapsePercentage),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: onIconPressed,
          ),
        ),
      ],
    );
  }
}
