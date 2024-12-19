import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/presentation/Analytics_page/analytics.screen.dart';
import 'package:phuong_for_organizer/presentation/chat_section.dart/chat_list_page.dart';
import 'package:phuong_for_organizer/presentation/organizer_profile_view_page/org_prof_view_screen.dart';
import 'package:phuong_for_organizer/presentation/user_booked_events_list/user_booked_events_list.dart';

class MainScreen extends StatefulWidget {
  final String organizerId;
  final int initialIndex;

  const MainScreen({
    Key? key,
    required this.organizerId,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late final List<Widget> _screens;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    
    // Wrap each screen in a black container
    _screens = [
      Theme(
        data: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          canvasColor: Colors.black,
        ),
        child: AnalyticsPage(),
      ),
      Theme(
        data: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          canvasColor: Colors.black,
        ),
        child: const OrganizerChatListScreen(),
      ),
      Theme(
        data: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          canvasColor: Colors.black,
        ),
        child: EventRevenuePage(),
      ),
    ];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      _animationController.reset();
      _animationController.forward();
      
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        body: Stack(
          children: [
            // Black background layer
            Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
            ),
            
            // Content with fade transition
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                color: Colors.black,
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _screens,
                ),
              ),
            ),

            // Navigation bar with gradient
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.9),
                      Colors.black,
                    ],
                    stops: const [0.0, 0.4, 0.6, 0.8, 1.0],
                  ),
                ),
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(0, Icons.cloud_upload_outlined,
                          Icons.cloud_upload, 'Publish'),
                      _buildNavItem(
                          1, Icons.chat_bubble_outline, Icons.chat_bubble, 'Chat'),
                      _buildNavItem(2, Icons.show_chart, Icons.show_chart_outlined,
                          'Analytics'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, IconData selectedIcon, String label) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}