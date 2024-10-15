 //!globe

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/view/home_page/wiidgets/animation_text.dart';
import 'package:testing/view/home_page/wiidgets/autoScroll.dart';

Widget _buildBackground() {
    return Positioned(
      top: -550,
      right: -200,
      child: Container(
        width: 1200,
        height: 1300,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF153949),
              Color(0xFF0F232E),
              Colors.black,
              Colors.black
            ],
            end: Alignment.bottomCenter,
          ),
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.white,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        children: [
          _buildHoverableTextButton('AUTHORISE REQUEST'),
          const Text('/', style: TextStyle(color: Color(0xFFFF5E1D))),
          _buildHoverableTextButton('REFUSE REQUEST'),
          const Text('/', style: TextStyle(color: Color(0xFFFF5E1D))),
          _buildHoverableTextButton('ABOUT'),
          const SizedBox(width: 230),
          Text(
            'Phuong',
            style: GoogleFonts.greatVibes(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 690),
          SizedBox(
            height: 50,
            width: 150,
            child: OutlinedButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.black;
                  } else if (states.contains(MaterialState.hovered)) {
                    return const Color(0xFFFF5E1D);
                  }
                  return Colors.blueAccent;
                }),
                side: MaterialStateProperty.all(
                    const BorderSide(color: Color(0xFFFF5E1D), width: 2)),
              ),
              onPressed: () {},
              child: Text(
                'LOGOUT',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHoverableTextButton(String text) {
    return MouseRegion(
      onEnter: (event) =>
          print('Hovering $text'), // Detect when the mouse enters
      onExit: (event) =>
          print('Stopped hovering $text'), // Detect when the mouse exits
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return const Color(0xFFFF5E1D); // Change color on hover
            }
            return Colors.white; // Default color
          }),
        ),
        child: Text(
          text,
          style: GoogleFonts.orbitron(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Stack(
      children: [
        // Add the repeating text behind other elements
        Positioned(
          top: 560,
          left: 1,
          child: Transform.rotate(
            angle: 0,
            child: Text(
              'concert   ❋   get a ticket   ❋   reach your dream  ❋   get a ticket  ❋  get a ticket  ❋  get a ticket❋ get a ticket❋ get a ticket * get a ticket * get a ticket * get a ticket * ',
              style: GoogleFonts.orbitron(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned(
                  top: 60,
                  left: 40,
                  child: AnimatedGradientText(
                    text: 'GET READY TO\nEXPERIENCE THE\nBEST EVENTS',
                  ),
                ),
                Transform.rotate(
                    angle: 2.5,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 490, right: 1),
                      child: Icon(
                        Icons.arrow_back_outlined,
                        size: 80,
                        color: Color.fromARGB(255, 255, 17, 17),
                      ),
                    )),
                const Padding(
                  padding: EdgeInsets.only(left: 230, top: 430),
                  child: Text(
                    'WELCOME TO OUR CREATOR SIDE,\nWITH A SINGLE CLICK, YOU APPROVE OR REJECT BANDS,\nENSURING ONLY AUTHENTIC TALENT HITS THE STAGE',
                    style: TextStyle(
                        color: Color.fromARGB(255, 189, 189, 189),
                        fontSize: 17),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 870, top: 360),
                  child: getTicketButton(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1200, top: 250),
                  child: containerBeforeTheTicketButton(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget getTicketButton() {
    return Stack(children: [
      //?container-1
      Container(
        decoration: BoxDecoration(
          color: Colors.transparent, // Orange color
          borderRadius: BorderRadius.circular(80),
          border: Border.all(
            color: const Color(0xFFFF5E1D), // White border color
            width: 7, // Border width
          ),
        ),
        height: 110,
        width: 590,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15, left: 18),
        //?container-2
        child: Container(
          height: 80,
          width: 280,
          decoration: BoxDecoration(
            color: const Color(0xFFFF5E1D),
            borderRadius: BorderRadius.circular(70),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 23, left: 70),
            child: Text(
              'GET TICKET',
              style: GoogleFonts.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget containerBeforeTheTicketButton() {
    return Container(
        width: 350,
        height: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Music Festival',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'THE SUMMER\nFORMAL CONCERT',
                  style: GoogleFonts.anton(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 0.5,
                      color: Colors.black,
                      height: 1.2),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Adult Ticket',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '20.06.2023',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
                    ))),
          ),
        ]));
  }

//!second screen

Widget SecondScreen() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: const Color(0xFF7E9899),
      // Shadow effect
      boxShadow: [
        BoxShadow(
          color: Colors.black, // Shadow color
          spreadRadius: 15, // Spread of the shadow
          blurRadius: 40, // Blur effect
          offset: const Offset(0, 8), // Offset to position the shadow
        ),
      ],
    ),
    height: 1000,
    width: 1800,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(children: [
            Container(
              height: 800,
              width: 1480,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 0, 0, 0)),
              child: Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 650, top: 20),
                        child: Text(
                          '120 ',
                          style: GoogleFonts.montserrat(
                              fontSize: 130,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 1,
                              letterSpacing: -0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 900, top: 20),
                        child: Text(
                          'See all bands awaiting verification. Review their details,\ncheck their authenticity, and approve or reject them \nwith one click. ',
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              height: 1,
                              letterSpacing: -0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50, top: 80),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_forward_outlined,
                              size: 80,
                              color: Color.fromARGB(255, 255, 17, 17),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              'As an admin, you hold the ultimate authority to decide which bands make it to the stage. \nWith Phuong Admin Control, you’re not just approving performances; you’re curating experiences, \nshaping moments, and ensuring that every act hitting the spotlight is nothing short of spectacular.',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
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
//!SECOND SCREEN CONTAINER DESIGN THINKING

Widget SecondScreenContainer() {
  return Container(
      width: 550,
      height: 200,
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
                      fontSize: 30,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      height: 1,
                      letterSpacing: -0.9),
                ),
                const SizedBox(height: 20),
                Text(
                  'Design Society,\nCopenhagen, Denmar',
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 135, 135, 135),
                      fontWeight: FontWeight.bold,
                      height: 1,
                      letterSpacing: -0.9),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.black12,
                  child: const Icon(Icons.qr_code, size: 40),
                ),
                Text(
                  'Adult Ticket\n27.06.2023',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 81, 81, 81),
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ],
        ),
      ));
}
//!third screen



Widget thirdScreen() {
  return Container(
    width: double.infinity,

    height: 950,
    color: Colors.black,
    child: Stack(
      children: [
        // Scrolling images with opacity
        Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0.8,
                child: ImmersiveScrollingImages(startingIndex: 0, direction: 1),
              ),
              Opacity(
                opacity: 0.8,
                child: ImmersiveScrollingImages(startingIndex: 5, direction: -1),
              ),
              Opacity(
                opacity: 0.8,
                child: ImmersiveScrollingImages(startingIndex: 10, direction: 1),
              ),
              Opacity(
                opacity: 0.8,
                child: ImmersiveScrollingImages(startingIndex: 15, direction: -1),
              ),
            ],
          ),
        ),
        // Top vignette effect
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 200, // Adjust the height as needed
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
        // Bottom vignette effect
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 200, // Adjust the height as needed
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

Widget _buildEventCards() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 160,
        ),
        child: Text(
          'LAST EVENT IN THIS MONTH',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      const SizedBox(height: 500),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 200),
          child: Row(
            children: [
              _buildEventCard(
                'THE SUMMER\nFORMAL CONCERT',
                'Music Festival',
                '20.06.2023',
                '\$127.99',
              ),
              const SizedBox(width: 16),
              _buildEventCard(
                'DESIGN THINKING\nWORKSHOP',
                'Design Society,\nCopenhagen, Denmark',
                '27.06.2023',
                null,
              ),
              const SizedBox(width: 16),
              _buildEventCard(
                'TECH STARTUP\nCONFERENCE',
                'Innovation Hub',
                '15.07.2023',
                '\$199.99',
              ),
              const SizedBox(width: 16),
              _buildEventCard(
                'TECH STARTUP\nCONFERENCE',
                'Innovation Hub',
                '15.07.2023',
                '\$199.99',
              ),
              const SizedBox(width: 16),
              _buildEventCard(
                'TECH STARTUP\nCONFERENCE',
                'Innovation Hub',
                '15.07.2023',
                '\$199.99',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

//!SCROLL DOWN
Widget scrolledDown() {
  return Transform.rotate(
    angle: 1.58,
    child: Container(
      height: 80,
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFFF5E1D), // Orange color
        borderRadius: BorderRadius.circular(70), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 25),
        child: Row(
          children: [
            Text(
              'SCROLL DOWN',
              style: GoogleFonts.anton(
                  fontSize: 20, letterSpacing: 1, color: Colors.white),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 50,
            )
          ],
        ),
      ),
    ),
  );
}

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
            color: Colors.white,
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
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'BAND ORGANIZER APPROVAL',
          style: GoogleFonts.montserrat(
            color: Colors.white,
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
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: Colors.orange, size: 16),
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
