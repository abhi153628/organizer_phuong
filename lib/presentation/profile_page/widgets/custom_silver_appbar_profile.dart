import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/widgets/info_page.dart';

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
  }) : assert(scrollProgress >= 0.0 && scrollProgress <= 2.0),
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
          final double minAppBarHeight = 56.0; // Standard AppBar height
          final double maxAppBarHeight = 120.0; // Your expanded height
          
          // Calculate the percentage of collapse
          final double collapsePercentage = (maxAppBarHeight - appBarHeight) / (maxAppBarHeight - minAppBarHeight);
          final double clampedCollapsePercentage = collapsePercentage.clamp(0.0, 1.0);
          
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  appBarColorTween.evaluate(AlwaysStoppedAnimation(clampedCollapsePercentage))!,
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
                  bottom: 40 + (constraints.maxHeight - 72) * (.29 - clampedCollapsePercentage),
                  child: Text(
                    title,
                    style: GoogleFonts.
                    lato( color: titleColorTween.evaluate(AlwaysStoppedAnimation(clampedCollapsePercentage)),
                      fontSize: 20 + 4 * (1 - clampedCollapsePercentage), //  font size animation
                      fontWeight: FontWeight.bold,)
                  ),
                ),
                  Positioned(
                  left: 43,
                  top: 100 + (constraints.maxHeight - 65) * (.24 - clampedCollapsePercentage),
                  child: Text(
                    "Setting the stage for an unforgettable experience!",
                    style: GoogleFonts.aBeeZee( color: titleColorTween.evaluate(AlwaysStoppedAnimation(clampedCollapsePercentage)),
                      fontSize: 11 + 2 * (1 - clampedCollapsePercentage), // font size animation
                      fontWeight: FontWeight.w300,)
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        Padding(padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.info, color: Colors.redAccent),
            onPressed: (){
              Navigator.of(context).push(GentlePageTransition(page: EventHostingInfoPage()));
            },
          ),
        ),
      ],
    );
  }
}