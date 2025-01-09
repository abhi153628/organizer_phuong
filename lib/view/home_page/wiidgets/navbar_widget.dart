import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:testing/utils/transition_modal.dart';
import 'package:testing/res/colors.dart';
import 'package:testing/view/about_us/about_us_page.dart';
import 'package:testing/view/dashboard_screen/dash_board.dart';
import 'package:testing/view/dashboard_screen/widgets/approve_from_home_page.dart';


class HomePageWidgets {
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
                        GentlePageTransition(page:  PhuongAdminDashboard()),
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
      // ignore: avoid_print
      onEnter: (event) => print('Hovering $text'),
      // ignore: avoid_print
      onExit: (event) => print('Stopped hovering $text'),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
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
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16.0),
          ),
          foregroundColor: WidgetStateProperty.all(white),
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