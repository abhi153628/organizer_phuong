import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/modal/transition_modal.dart';
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
          //! THE BRAND-NAME --PHUONG
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
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.1, left: screenWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //! MAIN TEXT
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
                //! SUB TEXT
                Text(
                  "Easy Access to the popular events, party around you and seamless onboarding process can make user feel appreciated.",
                  style: GoogleFonts.rubik(
                    color: const Color.fromARGB(255, 152, 151, 151),
                    fontSize: screenWidth * 0.011,
                  ),
                ),
                SizedBox(height: screenHeight * 0.09),
                SizedBox(
                  width: screenWidth * 0.14,
                  child: Center(
                    //! LOGIN PAGE BUTTON
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
        // Scrolling images
        Positioned(
          top: screenHeight * 0.01,
          left: screenWidth * -0.3,
          child: const Row(
            children: [
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
