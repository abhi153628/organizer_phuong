import 'package:flutter/material.dart';
import 'package:testing/view/dashboard_screen/widgets/dashboard_content.dart';
import 'package:testing/view/dashboard_screen/widgets/sidebar.dart';


class ScalableWrapper extends StatelessWidget {
  final Widget child;
  final double designWidth;

  const ScalableWrapper({
    Key? key,
    required this.child,
    this.designWidth = 0.7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double currentWidth = constraints.maxWidth;
        double originalDesignWidth = MediaQuery.of(context).size.width * designWidth;
        double scaleFactor = currentWidth / originalDesignWidth;

        return Transform.scale(
          scale: scaleFactor,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: originalDesignWidth,
            child: child,
          ),
        );
      },
    );
  }
}

class PhuongAdminDashboard extends StatefulWidget {
  const PhuongAdminDashboard({Key? key}) : super(key: key);

  @override
  _PhuongAdminDashboardState createState() => _PhuongAdminDashboardState();
}

class _PhuongAdminDashboardState extends State<PhuongAdminDashboard> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> acceptedBands = [];
  List<Map<String, dynamic>> rejectedBands = [];
  int totalBands = 0;
  int pendingApprovals = 0;

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


    Widget dashboardContent = Row(
      children: [
      
          AdminSidebar(
            selectedIndex: _selectedIndex,
            onIndexChanged: updateSelectedIndex,
          ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth > 500 ? 32.0 : 16.0),
              child: DashboardContent(
                selectedIndex: _selectedIndex,
                totalBands: totalBands,
                pendingApprovals: pendingApprovals,
                rejectedBands: rejectedBands.length,
                rejectedEvents: rejectedBands.length,
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
  
      body: ScalableWrapper(
        designWidth: 1, 
        child: dashboardContent,
      ),
    );
  }
}