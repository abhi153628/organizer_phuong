import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const AdminSidebar({
    Key? key,
    required this.selectedIndex,
    required this.onIndexChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
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
    bool isActive = selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isActive
            ? const Color(0xFFFF5E1D).withOpacity(0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        leading:
            Icon(icon, color: isActive ? const Color(0xFFFF5E1D) : Colors.grey),
        title: Text(
          text,
          style: GoogleFonts.poppins(
            color: isActive ? const Color(0xFFFF5E1D) : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () => onIndexChanged(index),
      ),
    );
  }
}
