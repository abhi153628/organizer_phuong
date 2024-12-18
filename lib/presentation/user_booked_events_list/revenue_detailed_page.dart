import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/data/dataresources/booked_event_services.dart';
import 'package:phuong_for_organizer/data/models/booked_events_modal.dart';

// New model to represent event-specific details
class EventDetailModel {
  final String eventName;
  final double totalRevenue;
  final int totalBookings;
  final List<BookingModel> bookings;
  final DateTime eventDate;

  EventDetailModel({
    required this.eventName,
    required this.totalRevenue,
    required this.totalBookings,
    required this.bookings,
    required this.eventDate,
  });
}

// Extension method to add event-specific revenue calculation
extension EventRevenueExtension on OrganizerBookingService {
  Future<EventDetailModel> getEventSpecificDetails(String eventName) async {
    // Fetch all bookings for this specific event
    final allBookings = await getOrganizerEventBookings().first;
    final eventBookings = allBookings.where((booking) => booking.eventName == eventName).toList();

    return EventDetailModel(
      eventName: eventName,
      totalRevenue: eventBookings.fold(0.0, (sum, booking) => sum + booking.totalPrice),
      totalBookings: eventBookings.length,
      bookings: eventBookings,
      eventDate: eventBookings.isNotEmpty ? eventBookings.first.bookingTime : DateTime.now(),
    );
  }
}

// New Screen for Event-Specific Details
class EventDetailScreen extends StatelessWidget {
  final String eventName;
  final OrganizerBookingService _bookingService = OrganizerBookingService();

  // Minimalist color palette
  final Color _backgroundColor = black;
  final Color _primaryColor = purple;
  final Color _textColor = Colors.white;

  EventDetailScreen({Key? key, required this.eventName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: FutureBuilder<EventDetailModel>(
          future: _bookingService.getEventSpecificDetails(eventName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            if (!snapshot.hasData || snapshot.data!.bookings.isEmpty) {
              return _buildNoBookingsState();
            }

            final eventDetails = snapshot.data!;

            return CustomScrollView(
              slivers: [
                // Animated App Bar
                SliverAppBar(
                  backgroundColor: _backgroundColor,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: _textColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    eventName,
                    style: GoogleFonts.ibmPlexSans(
                      color: _textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ).animate().fadeIn(duration: 600.ms),
                  centerTitle: false,
                  floating: true,
                ),

                // Event Overview Section
                SliverToBoxAdapter(
                  child: _buildEventOverviewCard(eventDetails),
                ),

                // Detailed Booking Insights
                SliverToBoxAdapter(
                  child: _buildDetailedInsightsSection(eventDetails),
                ),

                // Bookings List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildBookingItem(eventDetails.bookings[index], index),
                    childCount: eventDetails.bookings.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventOverviewCard(EventDetailModel eventDetails) {
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
          _buildStatItem('Total Revenue', '\₹${eventDetails.totalRevenue.toStringAsFixed(2)}'),
          Container(
            height: 40,
            width: 1,
            color: _primaryColor.withOpacity(0.2),
          ),
          _buildStatItem('Total Bookings', eventDetails.totalBookings.toString()),
        ],
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .slide(begin: const Offset(0, 0.1));
  }

Widget _buildDetailedInsightsSection(EventDetailModel eventDetails) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _backgroundColor.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Insights',
          style: GoogleFonts.ibmPlexSans(
            color: _primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildInsightRow(
          'Avg. Ticket Price', 
          '\₹${(eventDetails.totalRevenue / eventDetails.totalBookings).toStringAsFixed(2)}'
        ),
        _buildInsightRow(
          'Event Date', 
          DateFormat('dd MMM yyyy').format(eventDetails.eventDate)
        ),
        _buildInsightRow(
          'Seats Booked', 
          eventDetails.bookings.fold<int>(0, (sum, booking) => sum + booking.seatsBooked).toString()
        ),
      ],
    ),
  ).animate()
    .fadeIn(duration: 600.ms);
}

  Widget _buildInsightRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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

  Widget _buildBookingItem(BookingModel booking, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        booking.userName,
        style: GoogleFonts.ibmPlexSans(
          color: _textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        DateFormat('dd MMM yyyy HH:mm').format(booking.bookingTime),
        style: GoogleFonts.ibmPlexSans(
          color: _textColor.withOpacity(0.7),
        ),
      ),
      trailing: Text(
        '\₹${booking.totalPrice.toStringAsFixed(2)}',
        style: GoogleFonts.ibmPlexSans(
          color: _primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .slide(
        begin: Offset(index.isEven ? 0.2 : -0.2, 0), 
        end: Offset.zero,
      );
  }

  Widget _buildLoadingState() {
    return Center(
      child:Lottie.asset('asset/animation/Animation - 1731642056954.json',height: 400)
    );
  }

  Widget _buildNoBookingsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: _primaryColor.withOpacity(0.7),
          ).animate()
            .scale(duration: 500.ms)
            .shake(duration: 500.ms),
          const SizedBox(height: 16),
          Text(
            'No Bookings for this Event',
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

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            color: _primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.ibmPlexSans(
            color: _textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}