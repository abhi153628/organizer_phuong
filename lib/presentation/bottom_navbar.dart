import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/presentation/Analytics_page/analytics.screen.dart';
import 'package:phuong_for_organizer/presentation/chat_section.dart/chat_list_page.dart';

import 'package:phuong_for_organizer/presentation/organizer_profile_view_page/org_prof_view_screen.dart';
import 'package:phuong_for_organizer/presentation/user_booked_events_list/user_booked_events_list.dart';

class MainScreen extends StatefulWidget {
  final String organizerId;
  final int initialIndex;

   MainScreen({
    Key? key, 
    required this.organizerId,
    this.initialIndex = 0, // Default to first tab
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _screens = [
      AnalyticsPage(),
        OrganizerChatListScreen(),
      OrganizerProfileViewScreen(organizerId: widget.organizerId),
      MinimalistOrganizerBookingsScreen()
    
      
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Display the selected screen
          _screens[_selectedIndex],

          // Persistent bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
                   _buildNavItem(1, Icons.chat, Icons.person, 'chat'),
                  _buildNavItem(2, Icons.person_outline, Icons.person, 'Profile'),
                    _buildNavItem(3, Icons.person_outline, Icons.person, 'events'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData selectedIcon, String label) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? Colors.white : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
