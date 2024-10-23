import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:testing/modal/firebase_service.dart';
import 'package:testing/view/home_page/wiidgets/cstm_alertbox.dart';

// Import the Firebase service

class ProfilePage extends StatefulWidget {
  final double width;
  final String organizerId;
  final Function(String, String)? onStatusUpdate;

  const ProfilePage(
      {Key? key,
      this.width = double.infinity,
      required this.organizerId,
      this.onStatusUpdate})
      : super(key: key);

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

  final FirebaseProfileService _profileService = FirebaseProfileService();
  Map<String, dynamic> _profileData = {};
  bool _isLoading = true;

  final List<Color> _backgroundGradient = [
    Colors.orange.withOpacity(0.5),
    const Color(0xFFFF5E1D).withOpacity(0.3),
    Colors.transparent,
    Colors.transparent
  ];

  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchProfileData();
  }

 void _handleStatusUpdate(String status) {
    if (widget.onStatusUpdate != null) {
      widget.onStatusUpdate!(widget.organizerId, status);
      
      // First pop the alert dialog if it exists
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      // Then pop the profile page dialog
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  void _setupAnimations() {
    _mainController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _scaleAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _mainController.forward();
  }

  Future<void> _fetchProfileData() async {
    try {
      final data = await _profileService.getProfileData(widget.organizerId);

      setState(() {
        _profileData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching profile data: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load profile data')),
      );
    }
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : AnimatedBuilder(
                animation: _backgroundController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: _backgroundGradient,
                        transform: GradientRotation(
                            _backgroundController.value * 2 * math.pi),
                      ),
                    ),
                    child: child,
                  );
                },
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double maxWidth = constraints.maxWidth;
                      double avatarSize =
                          maxWidth < 600 ? maxWidth * 0.25 : 150;
                      double fontSize = maxWidth < 600 ? 20 : 28;

                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            width: maxWidth * 0.9,
                            height: maxWidth * 0.9,
                            padding: const EdgeInsets.all(2),
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
                                          child: Container(
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: avatarSize / 1,
                                                  backgroundImage: const AssetImage(
                                                      'asset/back-view-crowd-fans-watching-live-concert-performance-6.jpg'),
                                                  child: _profileData[
                                                              'imageUrl'] !=
                                                          null||_profileData[
                                                              'imageUrl'] !=''
                                                      ? ClipOval(
                                                          child:
                                                              CachedNetworkImage(
                                                          imageUrl: _profileData[
                                                                  'imageUrl'] ??
                                                              '',
                                                          fit: BoxFit.cover,
                                                          width: avatarSize * 2,
                                                          height:
                                                              avatarSize * 2,
                                                          placeholder: (context,
                                                                  url) =>
                                                              const CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                              url, error) {
                                                            print(
                                                                'Error loading image: $error');
                                                            print(
                                                                'Error details: ${error.toString()}');
                                                            return const Icon(
                                                                Icons.error);
                                                          },
                                                        ))
                                                      : null,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                            70, 16, 13, 13)
                                                        .withOpacity(0.9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: FittedBox(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: FadeTransition(
                                                        opacity: _fadeAnimation,
                                                        child: Text(
                                                            _profileData[
                                                                    'name'] ??
                                                                'Name Not Available',
                                                            style: GoogleFonts.gabriela(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 28)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Container(
                                        width: 650,
                                        height: 300,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                                  70, 16, 13, 13)
                                              .withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            FadeTransition(
                                              opacity: _fadeAnimation,
                                              child: Text(
                                                _profileData['description'] ??
                                                    'Description Not Available',
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 70),
                                              child: FadeTransition(
                                                opacity: _fadeAnimation,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Lottie.asset(
                                                      'asset/Animation - 1728643625531.json',
                                                      width: 70,
                                                      height: 70,
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Text(
                                                      _profileData[
                                                              'location'] ??
                                                          'Location Not Available',
                                                      style:
                                                          GoogleFonts.aBeeZee(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 17),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            FadeTransition(
                                              opacity: _fadeAnimation,
                                              child: SelectableText(
                                                _profileData['phoneNumber'] ??
                                                    'Phone Number Not Available',
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            FadeTransition(
                                              opacity: _fadeAnimation,
                                              child: SelectableText(
                                                _profileData['email'] ??
                                                    'Email Not Available',
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            //! accept button
                                            const SizedBox(height: 30),
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
                                                    child: OutlinedButton(
                                                      onPressed:  () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlertDialog(
                                      title: 'Final Confirmation',
                                      subtitle: 'Are you sure you want to accept this event organizer? This is your last chance to review their profile details before proceeding. Once confirmed, the decision is final.',
                                      confirmButtonText: 'Yes, Accept',
                                      cancelButtonText: 'Review Again',
                                      onConfirm: () => _handleStatusUpdate('rejected'),
                                      onCancel: () => Navigator.of(context).pop(),
                                    );
                                  },
                                ),
                                                      child: Text(
                                                        'Reject',
                                                        style:
                                                            GoogleFonts.aBeeZee(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                      ),
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 15),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                    width: 200,
                                                    child: OutlinedButton.icon(
                                                      onPressed: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlertDialog(
                                      title: 'Final Confirmation',
                                      subtitle: 'Are you sure you want to accept this event organizer? This is your last chance to review their profile details before proceeding. Once confirmed, the decision is final.',
                                      confirmButtonText: 'Yes, Accept',
                                      cancelButtonText: 'Review Again',
                                      onConfirm: () => _handleStatusUpdate('approved'),
                                      onCancel: () => Navigator.of(context).pop(),
                                    );
                                  },
                                ),
                                                      label: Text(
                                                        'Accept',
                                                        style:
                                                            GoogleFonts.aBeeZee(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                                0xFFFF5E1D),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 15),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
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
