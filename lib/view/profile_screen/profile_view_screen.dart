import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  final double width;

  const ProfilePage({Key? key, this.width = double.infinity}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _backgroundController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<Color> _backgroundGradient = [
    Colors.teal.withOpacity(0.5),
       Colors.green.withOpacity(0.5),
    Colors.transparent,
      Colors.transparent
    // Colors.green,
  ];

  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _scaleAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Interval(0.0, 0.5, curve: Curves.elasticOut),
    );


    _slideAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.1, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 800,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: _backgroundGradient,
                  transform: GradientRotation(
                      _backgroundController.value * 1 * math.pi),
                ),
              ),
              child: child,
            );
          },
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth;
                double avatarSize = maxWidth < 600 ? maxWidth * 0.25 : 150;
                double fontSize = maxWidth < 600 ? 20 : 28;

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      width: maxWidth * 0.9,
                      height: maxWidth * 0.9,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(70, 16, 13, 13)
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Opacity(
                                  opacity: 0.9,
                                  child: Image.asset(
                                    'asset/back-view-excited-audience-with-arms-raised-cheering-front-stage-music-concert-copy-space.jpg',
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  ))),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: Hero(
                                  tag: 'profileImage',
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isLiked = !_isLiked;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _isLiked
                                              ? Colors.red
                                              : Colors.transparent,
                                          width: 4,
                                        ),
                                      ),
                                      //todo: Event organizer photo
                                      child: Container(
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: avatarSize / 1,
                                              backgroundImage: NetworkImage(
                                                  'asset/back-view-crowd-fans-watching-live-concert-performance-6.jpg'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 60,),
                              Center(
                                //!text and button container
                                child: Container(
                                  width: 650,
                                  height: 300,
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(70, 16, 13, 13)
                                        .withOpacity(0.9),
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
                                    children: [
                                      SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(-1, 0),
                                          end: Offset.zero,
                                        ).animate(_slideAnimation),
                                        child: FadeTransition(
                                          opacity: _fadeAnimation,
                                          //todo: Event organizer name
                                          child: Text('John Doe',
                                              style: GoogleFonts.aBeeZee(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 28)),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      FadeTransition(
                                        opacity: _fadeAnimation,
                                        //todo: Event organizer description
                                        child: Text(
                                          'Flutter Developer & UI/UX Enthusiast',
                                          style: GoogleFonts.aBeeZee(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(_fadeAnimation),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Lottie.asset(
                                              'asset/Animation - 1728643625531.json',
                                              width: 70,
                                              height: 70,
                                            ),
                                            SizedBox(width: 5),
                                            //todo: Event organizer location
                                            Text('New York, USA',
                                                 style: GoogleFonts.aBeeZee(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17),
                                          textAlign: TextAlign.center,)
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 80),
                                      FadeTransition(
                                        opacity: _fadeAnimation,
                                        child: Wrap(
                                          spacing: 30,
                                          runSpacing: 20,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              width: 200,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Profile Accepted!')),
                                                  );
                                                },
                                                icon: Icon(Icons.check,size: 40,),
                                                label: Text('Accept',    style: GoogleFonts.aBeeZee(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 15),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 200,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Profile Rejected')),
                                                  );
                                                },
                                                icon: Icon(Icons.close,size: 40,),
                                                label: Text('Reject' ,   style: GoogleFonts.aBeeZee(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 15),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
