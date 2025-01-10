// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_drawer.dart';
import 'package:phuong_for_organizer/data/dataresources/booked_event_services.dart';
import 'package:phuong_for_organizer/data/models/booked_events_modal.dart';
import 'package:phuong_for_organizer/presentation/user_booked_events_list/revenue_detailed_page.dart';

class Bookings extends StatefulWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  final OrganizerBookingService _bookingService = OrganizerBookingService();

  // Minimalist color palette
  final Color _backgroundColor = black;
  final Color _primaryColor = purple;
  final Color _textColor = Colors.white;
  final TextEditingController _searchController = TextEditingController();
  List<BookingModel> _allBookings = [];
  List<BookingModel> _filteredBookings = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadAllBookings();
  }

  // Load all bookings for search functionality
  Future<void> _loadAllBookings() async {
    final bookings = await _bookingService.getOrganizerEventBookings().first;
    setState(() {
      _allBookings = bookings;
      _filteredBookings = bookings;
    });
  }

  // Search functionality
  void _searchBookings(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredBookings = _allBookings.where((booking) => 
        booking.eventName.toLowerCase().contains(query.toLowerCase()) ||
        booking.userName.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  // Clear search
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _filteredBookings = _allBookings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(drawer: CustomDrawer(),
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Minimalist App Bar
            SliverAppBar(  iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: _backgroundColor,
              elevation: 0,
              expandedHeight: 50,
              title: Text(
                'Bookings',
                style: GoogleFonts.ibmPlexSans(
                  color: _textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms),
              centerTitle: false,
              floating: true,
            ),

            // Search Bar as SliverToBoxAdapter
            SliverToBoxAdapter(
              child: _buildAnimatedSearchBar(),
            ),

            // Stats Section
            SliverToBoxAdapter(
              child: _buildMinimalistStatsSummary(),
            ),

            // Bookings List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildBookingItem(_filteredBookings[index], index),
                ),
                childCount: _filteredBookings.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
         
          color: _backgroundColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isSearching ? _primaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _searchBookings,
          style: GoogleFonts.ibmPlexSans(
            color: _textColor,
            fontSize: 16,
          
          ),
          decoration: InputDecoration(
            hintText: 'Search bookings...',
            hintStyle: GoogleFonts.ibmPlexSans(
              color: _textColor.withOpacity(0.6),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: _isSearching ? _primaryColor : _textColor.withOpacity(0.6),
            ),
            suffixIcon: _isSearching
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: _primaryColor,
                    ),
                    onPressed: _clearSearch,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          
        ),
      ),
    );
  }

  // Modified Bookings List to use filtered bookings
  // ignore: unused_element
  Widget _buildMinimalistBookingsList() {
    // If search is active and no results found
    if (_isSearching && _filteredBookings.isEmpty) {
      return _buildNoSearchResultsState();
    }

    // Use filtered bookings instead of the stream
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredBookings.length,
      separatorBuilder: (context, index) => Divider(
        color: _primaryColor.withOpacity(0.2),
        height: 1,
      ),
      itemBuilder: (context, index) {
        final booking = _filteredBookings[index];
        return _buildBookingItem(booking, index);
      },
    );
  }

  // No Search Results State
  Widget _buildNoSearchResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: _primaryColor.withOpacity(0.7),
          )
          .animate()
          .scale(duration: 500.ms)
          .shake(duration: 500.ms),
          const SizedBox(height: 16),
          Text(
            'No Bookings Found',
            style: GoogleFonts.ibmPlexSans(
              color: _textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: GoogleFonts.ibmPlexSans(
              color: _textColor.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalistStatsSummary() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchOrganizerStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildStatsPlaceholder();
        }

        final revenue = snapshot.data?['revenue'] ?? 0.0;
        final bookingsCount = snapshot.data?['bookingsCount'] ?? 0;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: _backgroundColor.withOpacity(0.8),
            border: Border.all(color: _primaryColor.withOpacity(0.3), width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            _buildStatItem('Revenue', '₹${revenue.toStringAsFixed(2)}'),
              Container(
                height: 40,
                width: 1,
                color: _primaryColor.withOpacity(0.2),
              ),
              _buildStatItem('Bookings', bookingsCount.toString()),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .slide(begin: const Offset(0, 0.1),);
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            color: _primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.ibmPlexSans(
            color: red.withOpacity(0.8),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


  Widget _buildBookingItem(BookingModel booking, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        booking.eventName,
        style: GoogleFonts.ibmPlexSans(
          color: _textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
   subtitle: Text(
  // ignore: unnecessary_null_comparison
  (booking.userName != null && booking.userName.isNotEmpty)
      ? booking.userName
      : 'Unknown User',
  style: GoogleFonts.ibmPlexSans(
    color: _textColor.withOpacity(0.7),
  ),
),

      trailing: Text(
        '\₹${booking.totalPrice.toStringAsFixed(2)}',
        style: GoogleFonts.ibmPlexSans(
          color: _primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),
      ),
      onTap: () => _navigateToEventDetails(booking.eventName),
    )
    .animate()
    .fadeIn(duration: 600.ms)
    .slide(
      begin: Offset(index.isEven ? 0.2 : -0.2, 0), 
      end: Offset.zero,
    );
  }
  void _navigateToEventDetails(String eventName) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => EventDetailScreen(eventName: eventName),
    ),
  );
}

  // ignore: unused_element
  void _showBookingDetails(BookingModel booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.eventName,
              style: GoogleFonts.ibmPlexSans(
                color: _primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Booked By', booking.userName),
            _buildDetailRow('Seats', booking.seatsBooked.toString()),
            _buildDetailRow(
              'Booking Time', 
              DateFormat('dd MMM yyyy HH:mm').format(booking.bookingTime)
            ),
            _buildDetailRow(
              'Total Price', 
              '\$${booking.totalPrice.toStringAsFixed(2)}'
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              color: _textColor.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.ibmPlexSans(
              color: _textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsPlaceholder() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 100,
      decoration: BoxDecoration(
        color: _backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildBookingsPlaceholder() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        height: 70,
        decoration: BoxDecoration(
          color: _backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: _primaryColor.withOpacity(0.7),
          )
          .animate()
          .scale(duration: 500.ms)
          .shake(duration: 500.ms),
          const SizedBox(height: 16),
          Text(
            'No Bookings Yet',
            style: GoogleFonts.ibmPlexSans(
              color: _textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchOrganizerStats() async {
    final revenue = await _bookingService.getOrganizerTotalRevenue();
    final bookingsCount = await _bookingService.getOrganizerTotalBookings();
    return {
      'revenue': revenue,
      'bookingsCount': bookingsCount,
    };
  }
}