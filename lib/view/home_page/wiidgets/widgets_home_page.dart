import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/res/colors.dart';
import 'package:testing/view/home_page/wiidgets/autoScroll.dart';
//! GET TICKET BUTTON
Widget getTicketButton(BuildContext context) {
  // Get the screen width
  double screenWidth = MediaQuery.of(context).size.width;

  // Define responsive dimensions
  double containerHeight = screenWidth > 1200 ? 80 : (screenWidth > 800 ? 70 : 60);
  double containerWidth = screenWidth > 1200 ? 300 : (screenWidth > 800 ? 250 : 200);
  double innerButtonHeight = screenWidth > 1200 ? 55 : (screenWidth > 800 ? 50 : 45);
  double innerButtonWidth = screenWidth > 1200 ? 150 : (screenWidth > 800 ? 130 : 120);
  double fontSize = screenWidth > 1200 ? 15 : (screenWidth > 800 ? 14 : 12);

  return Stack(
    children: [
      // Outer container
      Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(80),
          border: Border.all(
            color: orange,
            width: screenWidth > 1200 ? 7 : (screenWidth > 800 ? 6 : 5),
          ),
        ),
        height: containerHeight,
        width: containerWidth,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 13, left: 16),
        // Inner button container
        child: Container(
          height: innerButtonHeight,
          width: innerButtonWidth,
          decoration: BoxDecoration(
            color: orange,
            borderRadius: BorderRadius.circular(70),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 25),
            child: Text(
              'GET TICKET',
              style: GoogleFonts.orbitron(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    ],
  );
}

//! containerBeforeTheTicketButton
Widget containerBeforeTheTicketButton(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  // Set the width, height, and font sizes based on the screen width
  double containerWidth = screenWidth > 1200 ? 250 : (screenWidth > 800 ? 280 : 250);
  double containerHeight = screenWidth > 1200 ? 350 : (screenWidth > 800 ? 380 : 340);
  double titleFontSize = screenWidth > 1200 ? 36 : (screenWidth > 800 ? 10 : 2);
  double subtitleFontSize = screenWidth > 1200 ? 18 : (screenWidth > 800 ? 16 : 14);

  return Container(
    
    width: containerWidth,
    height: containerHeight,
    decoration: BoxDecoration(
      color: Colors.white, // Ensure 'white' is defined properly
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 5,
        ),
      ],
    ),
    
    child: Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          if (screenWidth > 1200) 
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                if (screenWidth > 1200) 
              Text(
                'Music Festival',
                style: TextStyle(
                  
                  color: Colors.grey[600],
                  fontSize: subtitleFontSize,
                  
                ),maxLines: 2,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 8),
                if (screenWidth > 1200) 
              Text(
                'THE SUMMER\nFORMAL CONCERT',
                style: GoogleFonts.anton(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 0.5,
                  color: Colors.black, // Ensure 'black' is defined properly
                  height: 1.2,
                ),
                overflow: TextOverflow.visible,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              const Text(
                'Adult Ticket',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 4),
              const Text(
                '20.06.2023',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
          if (screenWidth > 800) 
        Expanded(
          
          child: Container(
            
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF3E0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'asset/WhatsApp Image 2024-10-01 at 09.37.05_044c4e8f.jpg',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


// ! SECOND LAYOUT SCREEN

// ignore: non_constant_identifier_names
Widget saecondScreen(BuildContext context) {
   double screenWidth = MediaQuery.of(context).size.width;
  
  return Container(
    
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: const Color(0xFF7E9899),
      boxShadow: [
        const BoxShadow(
          color: Colors.black,
          spreadRadius: 15,
          blurRadius: 40,
          offset: Offset(0, 8),
        ),
      ],
    ),
    height: 900,
    width: 1500,
    child: Column(
      
      children: [
      
          
        
        Padding(
          
          padding: const EdgeInsets.only(top: 70),
          child: Stack(children: [
            
            Container(
              height: 650,
              width: 1170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: black),
              child: Row(
                children: [
                  Column(
                    children: [
                          if (screenWidth > 600) 
                      Padding(
                        padding: const EdgeInsets.only(left: 500, top: 20),
                        child: Text(
                          '120 ',
                          style: GoogleFonts.montserrat(
                              fontSize: 100,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 1,
                              letterSpacing: -0.5),
                        ),
                      ),
                          if (screenWidth > 800) 
                      Padding(
                        padding: const EdgeInsets.only(left: 700, top: 20),
                        child: Text(
                          'See all bands awaiting verification. Review their details,\ncheck their authenticity, and approve or reject them \nwith one click. ',
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: white,
                              fontWeight: FontWeight.w300,
                              height: 1,
                              letterSpacing: -0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50, top: 190),
                        child: Row(
                          children: [
                                if (screenWidth > 1000) 
                             Icon(
                              Icons.arrow_forward_outlined,
                              size: 60,
                              color: orange,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                                if (screenWidth > 1000) 
                            Text(
                              'As an admin, you hold the ultimate authority to decide which bands make it to the stage. \nWith Phuong Admin Control, you’re not just approving performances; you’re curating experiences, \nshaping moments, and ensuring that every act hitting the spotlight is nothing short of spectacular.',
                              style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  color:
                                      const Color.fromARGB(255, 189, 189, 189),
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                  letterSpacing: -0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    ),
  );
}
// !CONTAINER  IN SECOND SCREEN

Widget secondScreenContainer(BuildContext context) {
  // Get the screen dimensions
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  // Define responsive dimensions
  double containerWidth = screenWidth > 600 ? 500 : screenWidth * 0.9; // 90% width for mobile
  double containerHeight = screenHeight * 0.25; // 25% of screen height for better responsiveness

  double titleFontSize = screenWidth > 600 ? 27 : 20; // Responsive font size for title
  double subtitleFontSize = screenWidth > 600 ? 14 : 12; // Responsive font size for subtitle
  double ticketFontSize = screenWidth > 600 ? 14 : 12; // Responsive font size for ticket info

  return Container(
    width: containerWidth,
    height: containerHeight,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DESIGN THINKING\nWORKSHOP',
                style: GoogleFonts.roboto(
                  fontSize: titleFontSize,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  height: 1,
                  letterSpacing: -0.9,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Design Society,\nCopenhagen, Denmark',
                style: GoogleFonts.roboto(
                  fontSize: subtitleFontSize,
                  color: const Color.fromARGB(255, 135, 135, 135),
                  fontWeight: FontWeight.bold,
                  height: 1,
                  letterSpacing: -0.9,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.qr_code, size: 40),
              ),
              Text(
                'Adult Ticket\n27.06.2023',
                style: GoogleFonts.roboto(
                  fontSize: ticketFontSize,
                  color: const Color.fromARGB(255, 81, 81, 81),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

//! THIRD LAYOUT SCREEN SCROLLING IMAGES

Widget thirdScreen(BuildContext context) {
  // Get screen dimensions using MediaQuery
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 768;
  final isMediumScreen = screenSize.width < 1024;

  return Container(
    width: double.infinity,
    height: 850,
    color: black,
    child: Stack(
      children: [
        // Scrollable content wrapper
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Container(
            // Ensure minimum width for content
            width: math.max(screenSize.width, 1200),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 8.0 : 16.0,
              ),
              child: Row(
                mainAxisAlignment: isSmallScreen
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (!isSmallScreen || !isMediumScreen) ...[
                    const Expanded(
                      child: Opacity(
                        opacity: 0.8,
                        child: ImmersiveScrollingImages(
                            startingIndex: 0, direction: 1),
                      ),
                    ),
                    const Expanded(
                      child: Opacity(
                        opacity: 0.8,
                        child: ImmersiveScrollingImages(
                            startingIndex: 5, direction: -1),
                      ),
                    ),
                  ],
                  // Always show at least two columns
                  const Expanded(
                    child: Opacity(
                      opacity: 0.8,
                      child: ImmersiveScrollingImages(
                          startingIndex: 10, direction: 1),
                    ),
                  ),
                  const Expanded(
                    child: Opacity(
                      opacity: 0.8,
                      child: ImmersiveScrollingImages(
                          startingIndex: 15, direction: -1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenSize.height * 0.3,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: screenSize.height * 0.2, // Responsive height
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),

        if (isSmallScreen)
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
      ],
    ),
  );
}

//! SCROLL DOWN BUTTON LIKE CONTAINER
Widget scrolledDown() {
  return Transform.rotate(
    angle: 1.57,
    child: Container(
      height: 60,
      width: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFFF5E1D),
        borderRadius: BorderRadius.circular(70), 
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 25),
        child: Row(
          children: [
            Text(
              'SCROLL DOWN',
              style: GoogleFonts.anton(
                  fontSize: 18, letterSpacing: 1, color: Colors.white),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 30,
            )
          ],
        ),
      ),
    ),
  );
}


//! SECOND SCREEN CONTENTS
  Widget _buildSecondScreen() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF7E9899),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 15,
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '120+',
                  style: GoogleFonts.montserrat(
                    fontSize: 100,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 0.8,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'See all bands awaiting verification. Review their details, check their authenticity, and approve or reject them with one click.',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    height: 0.9,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Icon(
                        Icons.arrow_forward_outlined,
                        size: 40, // Further reduced
                        color: orange,
                      ),
                      const SizedBox(width: 8), // Further reduced
                      Expanded(
                        child: Text(
                          "As an admin, you hold the ultimate authority to decide which bands make it to the stage. With Phuong Admin Control, you're not just approving performances - you're curating experiences, shaping moments, and ensuring that every act hitting the spotlight is nothing short of spectacular.",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: const Color(0xFFBDBDBD),
                            fontWeight: FontWeight.w500,
                            height: 1,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
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
    );
  }
   Widget _buildThirdScreen() {
    return Container(
      height: 950,
      color: Colors.black,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.8,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.7,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[800],
                  margin: const EdgeInsets.all(4),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  

// ! CAROUSEL CARD CONTENT
Widget _buildEventCard(
  String title,
  String subtitle,
  String date,
  String? price,
) {
  return Container(
    width: 250,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(color: Colors.grey[400]),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: const TextStyle(color: Colors.orange),
            ),
            if (price != null)
              Text(
                price,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
// ! LAST PAGE DASHBOARD
Widget _buildAdminDashboard() {
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
          color: Colors.white.withOpacity(0.1),
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
            color:white,
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
                 Text(
                  'Pending Approvals: 5',
                  style: TextStyle(color:white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                     Icon(Icons.access_time,
                        color: orange, size: 16),
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
