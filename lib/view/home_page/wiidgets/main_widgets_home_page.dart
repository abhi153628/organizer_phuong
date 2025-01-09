// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/utils/transition_modal.dart';
import 'package:testing/res/colors.dart';
import 'package:testing/view/about_us/about_us_page.dart';
import 'package:testing/view/dashboard_screen/dash_board.dart';
import 'package:testing/view/dashboard_screen/widgets/approve_from_home_page.dart';
import 'package:testing/view/home_page/wiidgets/animation_text.dart';
import 'package:testing/view/home_page/wiidgets/widgets_home_page.dart';

class HomePageWidgets {
  //! Background Widget
  static Widget buildBackground() {
    return Positioned(
      top: -540,
      right: -280,
      child: Container(
        width: 1100,
        height: 1100,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF153949),
              Color(0xFF0F232E),
              black,
              black,
            ],
            end: Alignment.bottomCenter,
          ),
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: white,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
    );
  }

  //! BACKGROUND BUTTON LIKE WIDGET
  static Widget buttonPicture() {
    return Positioned(
      top: 130,
      right: 1100,
      child: Transform.rotate(
        angle: 0.19,
        child: Stack(children: [
          Container(
            width: 430,
            height: 700,
            decoration: const BoxDecoration(
              color: Color(0xFF2A2A2D),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(300),
                topRight: Radius.circular(300),
                bottomLeft: Radius.circular(200),
                bottomRight: Radius.circular(200),
              ),
            ),
          ),
          Positioned(
            top: 55,
            right: 40,
            child: Transform.rotate(
              angle: 0.0,
              child: Container(
                width: 350,
                height: 550,
                decoration: const BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(300),
                    topRight: Radius.circular(300),
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 280,
            right: 20,
            child: Transform.rotate(
              angle: 0.0,
              child: Container(
                width: 350,
                height: 400,
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2A2D),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(300),
                    topRight: Radius.circular(300),
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 340,
            right: 43,
            child: Transform.rotate(
              angle: 0.0,
              child: Container(
                width: 300,
                height: 280,
                decoration: const BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(500),
                    topRight: Radius.circular(500),
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  //! MAIN TEXT CONTENT
  static Widget buildMainContent(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const Positioned(
                  top: 60,
                  left: 20,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AnimatedGradientText(
                      text: 'GET READY TO \nEXPERIENCE THE \nBEST EVENTS',
                      fontSize: 85,
                    ),
                  ),
                ),
                if (screenWidth > 800)
                  Transform.rotate(
                    angle: 2.5,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 420, right: 1),
                      child: Icon(
                        Icons.arrow_back_outlined,
                        size: 60,
                        color: orange,
                      ),
                    ),
                  ),
                // Conditionally display the welcome text based on screen width
                if (screenWidth >
                    800) // Display only on screens wider than 600 pixels
                  const Padding(
                    padding: EdgeInsets.only(left: 200, top: 370),
                    child: Text(
                      'WELCOME TO OUR CREATOR SIDE,\nWITH A SINGLE CLICK, YOU APPROVE OR REJECT BANDS,\nENSURING ONLY AUTHENTIC TALENT HITS THE STAGE',
                      style: TextStyle(
                        color: Color.fromARGB(255, 189, 189, 189),
                        fontSize: 15,
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.only(left: 800, top: 330),
                  child: getTicketButton(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1050, top: 230),
                  child: containerBeforeTheTicketButton(context),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  //! LAST PAGEE OF THE HOMEPAGE
  static Widget buildAdminDashboard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF153949), Color(0xFF0F232E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: white.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ADMIN DASHBOARD',
            style: GoogleFonts.montserrat(
              color: orange,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'BAND ORGANIZER APPROVAL',
            style: GoogleFonts.montserrat(
              color: white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pending Approvals: 5',
                    style: TextStyle(color: white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Last updated: 2 hours ago',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildHeader(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    // Define breakpoint for mobile view
    const mobileBreakpoint = 768.0;

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        children: [
          if (screenWidth > mobileBreakpoint) ...[
            // Desktop view
            Expanded(
              child: Row(
                children: [
                  _buildHoverableTextButton(
                    context: context,
                    text: 'ADMIN DASHBOARD',
                    onPressed: () {
                      Navigator.of(context).push(
                        GentlePageTransition(
                            page:  PhuongAdminDashboard()),
                      );
                    },
                  ),
                  Text('/', style: TextStyle(color: orange)),
                  _buildHoverableTextButton(
                    context: context,
                    text: 'APPROVE REQUEST',
                    onPressed: () {
                      Navigator.of(context).push(
                        GentlePageTransition(page: const ApproveFromHomePage()),
                      );
                    },
                  ),
                  Text('/', style: TextStyle(color: orange)),
                  _buildHoverableTextButton(
                    context: context,
                    text: 'ABOUT',
                    onPressed: () {
                      Navigator.of(context).push(
                        GentlePageTransition(page: const AboutUsPage()),
                      );
                    },
                  ),
                  const Spacer(),
                  Text(
                    'Phuong',
                    style: GoogleFonts.greatVibes(
                      fontSize: 24,
                      color: white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ] else ...[
            // Mobile view
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black87,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMobileMenuItem(
                            context: context,
                            text: 'ADMIN DASHBOARD',
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              Navigator.of(context).push(
                                GentlePageTransition(
                                  page:  PhuongAdminDashboard(),
                                ),
                              );
                            },
                          ),
                          const Divider(color: Colors.white24),
                          _buildMobileMenuItem(
                            context: context,
                            text: 'APPROVE REQUEST',
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              Navigator.of(context).push(
                                GentlePageTransition(
                                  page: const ApproveFromHomePage(),
                                ),
                              );
                            },
                          ),
                          const Divider(color: Colors.white24),
                          _buildMobileMenuItem(
                            context: context,
                            text: 'ABOUT',
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              Navigator.of(context).push(
                                GentlePageTransition(
                                  page: const AboutUsPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const Spacer(),
            Text(
              'Phuong',
              style: GoogleFonts.greatVibes(
                fontSize: 24,
                color: white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
          ],
        ],
      ),
    );
  }

  static Widget _buildHoverableTextButton({
    required BuildContext context,
    required String text,
    required void Function()? onPressed,
  }) {
    return MouseRegion(
      onEnter: (event) => print('Hovering $text'),
      onExit: (event) => print('Stopped hovering $text'),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return orange;
            }
            return white;
          }),
        ),
        child: Text(
          text,
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  static Widget _buildMobileMenuItem({
    required BuildContext context,
    required String text,
    required void Function()? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16.0),
          ),
          foregroundColor: MaterialStateProperty.all(white),
        ),
        child: Text(
          text,
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
