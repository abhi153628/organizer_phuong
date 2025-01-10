// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/data/dataresources/firebase_auth_services.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/presentation/event_listing_page/event_listing_page.dart';
import 'package:phuong_for_organizer/presentation/organizer_profile_view_page/org_prof_view_screen.dart';
import 'package:phuong_for_organizer/presentation/wrapper.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  final OrganizerProfileAddingFirebaseService _organizerService =
      OrganizerProfileAddingFirebaseService();
  FirebaseAuthServices _authServices = FirebaseAuthServices();
  String? _organizerId;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadOrganizerId();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogout(BuildContext context) async {
  try {
    // Show confirmation dialog first
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: purple, width: 1),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout_rounded,
                  size: 48,
                  color: purple,
                ),
                const SizedBox(height: 16),
                Text(
                  'Confirm Logout',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to logout?',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: Lottie.asset(
                                'asset/animation/Loading_animation.json',
                                height: 150,
                                width: 150,
                              ),
                            );
                          },
                        );

                        // Perform logout
                        _authServices.signOut().then((_) {
                          // Pop loading dialog
                          Navigator.of(context).pop();

                          // Navigate to wrapper
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const Wrapper(),
                            ),
                            (route) => false,
                          );
                        }).catchError((e) {
                          // Pop loading dialog if still showing
                          Navigator.of(context).pop();
                          
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Logout failed: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: purple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  } catch (e) {
    print('Error in logout: $e');
  }
}
  Future<void> _loadOrganizerId() async {
    try {
      final profile = await _organizerService.getCurrentUserProfile();
      if (profile != null) {
        setState(() {
          _organizerId = profile.id;
        });
      }
    } catch (e) {
      print('Error loading organizer ID: $e');
    }
  }

  void _handleNavigation(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Close the drawer
    Navigator.pop(context);

    // Handle navigation based on index
    switch (index) {
      case 0:
        // Handle dashboard navigation if needed
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              body: EventListPage(),
            ),
          ),
        );
        break;
      case 2:
        if (_organizerId != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OrganizerProfileViewScreen(
                organizerId: _organizerId!,
              ),
            ),
          );
        }
        break;
      case 5:
        _handleLogout(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF1A1A1A),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Organizer Dashboard',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: white,
                      letterSpacing: 0.3,
                      wordSpacing: 6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(
                      icon: Icons.dashboard_rounded,
                      title: 'Dashboard',
                      index: 0,
                      onTap: () => _handleNavigation(context, 0),
                    ),
                    _buildMenuItem(
                      icon: Icons.calendar_today_rounded,
                      title: 'Scheduled Events',
                      index: 1,
                      onTap: () => _handleNavigation(context, 1),
                    ),
                    _buildMenuItem(
                      icon: Icons.account_circle,
                      title: 'Profile',
                      index: 2,
                      onTap: () => _handleNavigation(context, 2),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFF2C2C2C)),
              _buildMenuItem(
                icon: Icons.logout_outlined,
                title: 'LogOut',
                index: 5,
                onTap: () => _handleNavigation(context, 5),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required int index,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _selectedIndex == index
              ? purple.withOpacity(0.2)
              : Colors.transparent,
          border: _selectedIndex == index
              ? Border.all(color: purple, width: 1)
              : null,
        ),
        child: ListTile(
          dense: true,
          leading: Icon(
            icon,
            color: _selectedIndex == index ? purple : Colors.grey,
            size: 22,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.white : Colors.grey,
              fontSize: 15,
              fontWeight:
                  _selectedIndex == index ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}