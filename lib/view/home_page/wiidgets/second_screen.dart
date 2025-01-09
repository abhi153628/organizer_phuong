import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define a color constant for orange if not already defined
const Color orange = Color(0xFFFF5E1D);

class SecondScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get the current screen width
        final screenWidth = constraints.maxWidth;
        
        return Container(
          width: screenWidth < 800 ? screenWidth * 0.95 : 1200,
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth < 800 ? 10 : 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF7E9899),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 15,
                blurRadius: 40,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 120+ Text
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth < 800 ? 0 : 500,
                        ),
                        child: Text(
                          '120+',
                          style: GoogleFonts.montserrat(
                            fontSize: screenWidth < 800 ? 60 : 100,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description Text
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth < 800 ? 0 : 500,
                        ),
                        child: Text(
                          'See all bands awaiting verification. Review their details,\ncheck their authenticity, and approve or reject them\nwith one click.',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Bottom Section with Arrow and Text
                      Container(
                        padding: EdgeInsets.only(
                          left: screenWidth < 800 ? 0 : 500,
                          right: 20,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ignore: prefer_const_constructors
                            Icon(
                              Icons.arrow_forward,
                              size: 40,
                              color: orange,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                              "  'As an admin, you hold the ultimate authority to decide which bands make it to the stage. With Phuong Admin Control, you're not just approving performances; you're curating experiences, shaping moments, and ensuring that every act hitting the spotlight is nothing short of spectacular.'",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  color: Colors.grey[400],
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}