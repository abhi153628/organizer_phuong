// main.dart
import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/presentation/Analytics_page/analytics.screen.dart';
import 'package:phuong_for_organizer/presentation/organizer_profile_view_page/org_prof_view_screen.dart';




// main_screen.dart
class MainScreen extends StatefulWidget {
  String profileId;
  int pageIndex;
  MainScreen({required this.profileId,required this.pageIndex});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex=0 ;
  String data='' ;
  // Pages to be shown
   late final List<Widget> _pages;
  // final List<Widget> _pages = [
  //    AnalyticsPage(),
  //    OrganizerProfileViewScreen(organizerId:)


  
  // ];

@override
  void initState() {
      _selectedIndex=widget.pageIndex;
       _pages = [
      AnalyticsPage(),
      OrganizerProfileViewScreen(organizerId: widget.profileId),
    ];
    super.initState();
  }
  @override
  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Main content
        _pages[_selectedIndex],
        
        // Custom bottom navigation bar
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
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                ],
                stops: const [0.0, 0.2, 0.6, 1.0],
              ),
            ),
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
                  _buildNavItem(1, Icons.search_outlined, Icons.search, 'Search'),
                  _buildNavItem(2, Icons.library_music_outlined, Icons.library_music, 'Library'),
                  _buildNavItem(3, Icons.workspace_premium_outlined, Icons.workspace_premium, 'Premium'),
                ],
              ),
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
    onTap: () {
      setState(() {
        _selectedIndex = index;
      });
    },
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
}}
// Example page widgets
