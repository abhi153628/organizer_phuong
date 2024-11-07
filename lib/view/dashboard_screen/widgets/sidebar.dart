import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminSidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const AdminSidebar({
    Key? key,
    required this.selectedIndex,
    required this.onIndexChanged,
  }) : super(key: key);

  @override
  _AdminSidebarState createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  bool _isDrawerOpen = false;

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 800;

        if (isWideScreen) {
          return _buildSidebar();
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF111111),
              title: Text(
                'Admin Panel',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isDrawerOpen ? Icons.close : Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: _toggleDrawer,
                ),
              ],
            ),
            body: Stack(
              children: [
                if (_isDrawerOpen) _buildDropdownMenu(),
                // Main content can go here
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 200,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 40),
          _buildSidebarItem(Icons.dashboard, 'Dashboard', 0),
          _buildSidebarItem(Icons.music_note, 'Approved', 1),
          _buildSidebarItem(Icons.no_accounts, 'Rejected', 2),
          _buildSidebarItem(Icons.people, 'Pending', 4),
          const Spacer(),
          _buildSidebarItem(Icons.logout, 'Logout', 5),
        ],
      ),
    );
  }

  Widget _buildDropdownMenu() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 200,
        color: const Color(0xFF111111),
        child: Column(
          children: [
            _buildLogo(),
            const SizedBox(height: 16),
            _buildSidebarItem(Icons.dashboard, 'Dashboard', 0),
            _buildSidebarItem(Icons.music_note, 'Approved', 1),
            _buildSidebarItem(Icons.no_accounts, 'Rejected', 2),
            _buildSidebarItem(Icons.people, 'Pending', 4),
            _buildSidebarItem(Icons.logout, 'Logout', 5),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5E1D),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'P',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'PHUONG',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String text, int index) {
    bool isActive = widget.selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isActive
            ? const Color(0xFFFF5E1D).withOpacity(0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? const Color(0xFFFF5E1D) : Colors.grey,
        ),
        title: Text(
          text,
          style: GoogleFonts.poppins(
            color: isActive ? const Color(0xFFFF5E1D) : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          widget.onIndexChanged(index);
          setState(() {
            _isDrawerOpen = false;
          });
        },
      ),
    );
  }
}
