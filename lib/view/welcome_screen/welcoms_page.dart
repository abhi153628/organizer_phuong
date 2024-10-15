import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/modal/transition_modal.dart';
import 'package:testing/view/login_screen/login_page.dart';
import 'package:testing/view/welcome_screen/widgets/auto_scroll_welcome_page.dart';



class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(0, 213, 4, 4).withOpacity(0.1),
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 20, left: 24),
          child: Text(
            'Phuong',
            style: GoogleFonts.greatVibes(
              fontSize: 33,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          TextButton(child: const Text('Features'), onPressed: () {}),
          TextButton(child: const Text('Reviews'), onPressed: () {}),
          TextButton(child: const Text('About'), onPressed: () {}),
          TextButton(child: const Text('Help & Support'), onPressed: () {}),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return _buildWideLayout(context);
          } else {
            return _buildNarrowLayout();
          }
        },
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('EXPLORE \n TOP EVENTS \n NEAR BY YOU',
                    style: GoogleFonts.lato(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 79,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 16),
                Text(
                    "Easy Access to the popular events, party around you and seamless onboarding process can make user feel appreciated.",
                    style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 120, 120, 120),
                        fontSize: 20)),
                const SizedBox(height: 24),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                             Navigator.of(context)
                  .push(GentlePageTransition(page:  LoginPage()));
                     
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      shadowColor: const Color.fromARGB(255, 236, 236, 236),
                      minimumSize: const Size.fromHeight(60),
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                          "Login",
                          style: GoogleFonts.lato(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.search)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        // scrolling images
        const Positioned(
            top: -10,
            left: -160,
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: Row(
                children: [
                  ScrollingImages(startingIndex: 1),
                  ScrollingImages(startingIndex: 2),
                  ScrollingImages(startingIndex: 3),
                ],
              ),
            ))
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'EXPLORE TOP EVENTS NEAR BY YOU',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Easy Access to the popular events, workshop, party around you and seamless onboarding process can make user feel appreciated.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.search),
                label: const Text('Explore'),
              ),
            ],
          ),
        ),
        // widgets
      ],
    );
  }
}
