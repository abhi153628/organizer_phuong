import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/view/login_screen/widgets_of_login/right_panel_login_page_widgets.dart';

//! MOST STRUCTURED 
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveSignUpLayout(),
    );
  }
}












// ?_________________________________________________________________________________________________________________
//! MEDIAQUERY

class ResponsiveSignUpLayout extends StatelessWidget {
  const ResponsiveSignUpLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MediaQuery.of(context).size.width > 800
            ? _buildWideLayout(context, constraints)
            : _buildNarrowLayout(context, constraints);
      },
    );
  }
//! WIDGET OF RIGHT PANEL AND LEFT PANEL
  Widget _buildWideLayout(BuildContext context, BoxConstraints constraints) {
    return Row(
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.5,
          child: LeftPanel(constraints: constraints),
        ),
        SizedBox(
          width: constraints.maxWidth * 0.5,
          child: RigtPanelLogin(constraints: constraints),
        ),
      ],
    );
  }
//! SPLIT SCREEN WHEN SCREEN REDUCED- MEDIAQUERY
  Widget _buildNarrowLayout(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: constraints.maxWidth > 600
                ? constraints.maxHeight * 0.6
                : constraints.maxHeight * 0.4,
            child: LeftPanel(constraints: constraints),
          ),
          RigtPanelLogin(constraints: constraints),
        ],
      ),
    );
  }
}
//! BACKGROUND IMAGE , TEXTS
class LeftPanel extends StatelessWidget {
  final BoxConstraints constraints;

  const LeftPanel({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isWide = screenSize.width > 800;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'asset/crowd-people-with-raised-arms-having-fun-music-festival-by-night.jpg',
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
           
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(isWide ? 32.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phuong Admin Control   ═════════ ',
                style: GoogleFonts.abel(
                  color: Colors.white,
                  fontSize: _getResponsiveFontSize(17, screenSize),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unlock \nthe Stage for\nAuthentic Talent',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: _getResponsiveFontSize(50, screenSize),
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: isWide ? 20 : 12),
                  Text(
                    'Approve true talent and set the stage for unforgettable performances.',
                    style: GoogleFonts.abel(
                      color: Colors.white,
                      fontSize: _getResponsiveFontSize(15, screenSize),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _getResponsiveFontSize(double baseSize, Size screenSize) {
    double scaleFactor = screenSize.width / 1440;
    return baseSize * scaleFactor.clamp(0.7, 1.2);
  }
}