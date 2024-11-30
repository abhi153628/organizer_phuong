// event_detail_page.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';

import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';
import 'package:phuong_for_organizer/presentation/edit_page_event_hosting/edit_page_event.dart';

class EventDetailPage extends StatelessWidget {
  final EventHostingModal event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // Animated App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'event-image-${event.eventId}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: event.uploadedImageUrl ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: purple.withOpacity(0.1),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: purple,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: purple.withOpacity(0.1),
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white54,
                          size: 50,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => _navigateToEditPage(context),
              ),
            ],
          ),

          // Event Details
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Name with Animation
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 800),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      event.eventName ?? 'Untitled Event',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Event Info Cards
                  _buildInfoSection(
                    title: 'Event Details',
                    children: [
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        text: '${_formatDate(event.date)}',
                      ),
                      _buildInfoRow(
                        icon: Icons.access_time,
                        text: event.time?.format(context) ?? 'Time not specified',
                      ),
                      _buildInfoRow(
                        icon: Icons.location_on,
                        text: event.location ?? 'Location not specified',
                      ),
                      _buildInfoRow(
                        icon: Icons.timer,
                        text: '${event.eventDurationTime} hours',
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Price and Availability
                  _buildInfoSection(
                    title: 'Ticket Information',
                    children: [
                      _buildInfoRow(
                        icon: Icons.confirmation_number,
                        text: '₹${event.ticketPrice?.toStringAsFixed(2) ?? "Free"}',
                      ),
                      _buildInfoRow(
                        icon: Icons.event_seat,
                        text: '${event.seatAvailabilityCount?.toInt() ?? 0} seats available',
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Description
                  _buildInfoSection(
                    title: 'Description',
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          event.description ?? 'No description available',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (event.eventRules?.isNotEmpty ?? false) ...[
                    SizedBox(height: 20),
                    _buildInfoSection(
                      title: 'Event Rules',
                      children: [
                        ...event.eventRules!.map((rule) => _buildInfoRow(
                              icon: Icons.check_circle_outline,
                              text: rule,
                            )),
                      ],
                    ),
                  ],

                  SizedBox(height: 20),

                  // Contact Information
                  _buildInfoSection(
                    title: 'Contact Information',
                    children: [
                      if (event.email != null)
                        _buildInfoRow(
                          icon: Icons.email,
                          text: event.email!,
                        ),
                      if (event.instagramLink != null)
                        _buildInfoRow(
                          icon: Icons.camera_alt,
                          text: 'Instagram',
                          onTap: () => _launchURL(event.instagramLink!),
                        ),
                      if (event.facebookLink != null)
                        _buildInfoRow(
                          icon: Icons.facebook,
                          text: 'Facebook',
                          onTap: () => _launchURL(event.facebookLink!),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: purple.withOpacity(0.3),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: purple,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: purple,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Date not specified';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToEditPage(BuildContext context) {
    // Navigate to edit page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(event: event),
      ),
    );
  }

  void _launchURL(String url) async {
    // Implement URL launching using url_launcher package
  }
}
