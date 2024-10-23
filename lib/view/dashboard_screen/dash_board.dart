// lib/screens/admin/dashboard/phuong_admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/view/dashboard_screen/widgets/dashboard_content.dart';
import 'package:testing/view/dashboard_screen/widgets/dashboard_content_widget.dart';
import 'package:testing/view/dashboard_screen/widgets/dashboard_sidebar.dart';


class PhuongAdminDashboard extends StatefulWidget {
  const PhuongAdminDashboard({Key? key}) : super(key: key);

  @override
  _PhuongAdminDashboardState createState() => _PhuongAdminDashboardState();
}

class _PhuongAdminDashboardState extends State<PhuongAdminDashboard> {
  int _selectedIndex = 0;
  List<Map<String,dynamic>> acceptedBands =[];
  List<Map<String,dynamic>> rejecctedBands =[];
 
  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 5) {
      _handleLogout();
    }
  }

  void _handleLogout() {
    //todo logout
    print('Logout pressed');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Row(
        children: [
          if (screenWidth > 800)
            AdminSidebar(
              selectedIndex: _selectedIndex,
              onIndexChanged: updateSelectedIndex,
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(screenWidth > 600 ? 32.0 : 16.0),
                child: DashboardContent(selectedIndex: _selectedIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




