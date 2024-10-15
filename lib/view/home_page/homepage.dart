import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/modal/transition_modal.dart';
import 'package:testing/view/firebase_auth_services.dart';
import 'package:testing/view/home_page/wiidgets/animation_text.dart';
import 'package:testing/view/home_page/wiidgets/cauosel.dart';
import 'package:testing/view/home_page/wiidgets/widgets.dart';
import 'package:testing/view/profile_screen/profile_view_screen.dart';



class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    _buildBackground(),
                    Positioned(
                      top: 460,
                      left: 1500,
                      child: Container(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        height: 300,
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 220, left: 60),
                          child: Text(
                            'get a ticket ❋ ',
                            style: GoogleFonts.orbitron(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buttonPicture(),
                    Positioned(top: 770, child: SecondScreen()),
                    Positioned(top: 840, left: 850, child: scrolledDown()),
                    Positioned(top: 900, left: 200, child: SecondScreenContainer()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 48),
                        _buildMainContent(),
                        const Padding(
                          padding: EdgeInsets.only(top: 500, left: 20),
                          child: AnimatedEventCarousel(),
                        ),
                        const SizedBox(height: 1),
                        const SizedBox(height: 120),
                        thirdScreen(),
                        _buildAdminDashboard()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

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

  Widget _buttonPicture() {
    return Positioned(
      top: 130,
      right: 1350,
      child: Transform.rotate(
        angle: 0.19,
        child: Stack(children: [
          Container(
            width: 500,
            height: 900,
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
            right: 50,
            child: Transform.rotate(
              angle: 0.0,
              child: Container(
                width: 400,
                height: 650,
                decoration: const BoxDecoration(
                  color: Colors.black,
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
            top: 320,
            right: 30,
            child: Transform.rotate(
              angle: 0.0,
              child: Container(
                width: 450,
                height: 500,
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
            top: 380,
            right: 53,
            child: Transform.rotate(
              angle: 0.0,
              child: Container(
                width: 400,
                height: 380,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
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

  Widget _buildHeader(BuildContext context) {
     FirebaseAuthServices auth =FirebaseAuthServices();
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        children: [
          _buildHoverableTextButton(text: 'AUTHORISE REQUEST',onPressed: (){ }),
          const Text('/', style: TextStyle(color: Color(0xFFFF5E1D))),
          _buildHoverableTextButton(text:'REFUSE REQUEST',onPressed: (){}),
          const Text('/', style: TextStyle(color: Color(0xFFFF5E1D))),
          _buildHoverableTextButton(text:'ABOUT',onPressed: (){}),
          const SizedBox(width: 230),
          Text(
            'Phuong',
            style: GoogleFonts.greatVibes(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        
        ],
      ),
    );
  }

  Widget _buildHoverableTextButton({required String text,required void Function()? onPressed}) {
    return MouseRegion(
      onEnter: (event) => print('Hovering $text'),
      onExit: (event) => print('Stopped hovering $text'),
      child: TextButton(
        onPressed: () {
          //todo : navigation
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DetailPage(),
            //   ),
            // );
          
        },
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return const Color(0xFFFF5E1D);
            }
            return Colors.white;
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
                        color: Color.fromARGB(255, 189, 189, 189), fontSize: 17),
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
      Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(80),
          border: Border.all(
            color: const Color(0xFFFF5E1D),
            width: 7,
          ),
        ),
        height: 110,
        width: 590,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15, left: 18),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '120',
                  style: GoogleFonts.montserrat(
                    fontSize: 130,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'See all bands awaiting verification. Review their details, check their authenticity, and approve or reject them with one click.',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    height: 1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 80),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_forward_outlined,
                      size: 80,
                      color: Color(0xFFFF1111),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                       " As an admin, you hold the ultimate authority to decide which bands make it to the stage. With Phuong Admin Control, you're not just approving performances \n you're curating experiences, shaping moments, and ensuring that every act hitting the spotlight is nothing short of spectacular.",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: const Color(0xFFBDBDBD),
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
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
          // Scrolling images with opacity (placeholder)
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
          // Top vignette effect
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
          // Bottom vignette effect
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
}