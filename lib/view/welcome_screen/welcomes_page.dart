import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/utils/transition_modal.dart';
import 'package:testing/view/login_screen/signup_page.dart';
import 'package:testing/view/welcome_screen/widgets/auto_scroll_welcome_page.dart';
//! WELCOME PAGE
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
   @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.only(
              top: screenHeight * 0.03, left: screenWidth * 0.02),
          child: Text(
            'Phuong',
            style: GoogleFonts.greatVibes(
              fontSize: screenWidth * 0.02,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _buildWideLayout(context, screenWidth, screenHeight);
        },
      ),
    );
  }
//!? ----------------------------------------------------------------------------------------------------------------------------------------

//! WIDGETS FOR LAYOUT IN SCAFOLD
   Widget _buildWideLayout(
      BuildContext context, double screenWidth, double screenHeight) {
    return Stack(  // Changed from Row to Stack to allow Positioned widgets
      children: [
        Row(  // Keep the original Row for the left side content
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.1, left: screenWidth * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EXPLORE \nTOP EVENTS \nNEAR BY YOU',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: screenWidth * 0.06,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "Easy Access to the popular events,\nparty around you and seamless onboarding process can make user feel appreciated.",
                      style: GoogleFonts.rubik(
                        color: const Color.fromARGB(255, 152, 151, 151),
                        fontSize: screenWidth * 0.011,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.09),
                    SizedBox(
                      width: screenWidth * 0.14,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(GentlePageTransition(page: LoginPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                            shadowColor: const Color.fromARGB(255, 236, 236, 236),
                            minimumSize: Size.fromHeight(screenHeight * 0.07),
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              Text(
                                "Login",
                                style: GoogleFonts.aBeeZee(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: screenWidth * 0.010,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.search)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(  // Now correctly placed inside Stack
          top: screenHeight * 0.01,
          left: screenWidth * 0.5,  // Adjusted position to be on the right side
          child: Row(
            children: const [
              ScrollingImages(startingIndex: 1),
              ScrollingImages(startingIndex: 2),
              ScrollingImages(startingIndex: 3),
            ],
          ),
        ),
      ],
    );
  }
}
