import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/data/dataresources/event_hosting_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';
import 'package:phuong_for_organizer/presentation/event_detailed_page/event_detailed_page.dart';

class EventListPage extends StatelessWidget {
  final FirebaseEventService _eventService = FirebaseEventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Events',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('eventCollection')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorState();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          return _buildEventList(context, snapshot.data!.docs);
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 80,
          ),
          SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            color: Colors.grey[600]!,
            size: 80,
          ),
          SizedBox(height: 16),
          Text(
            'No events found',
            style: TextStyle(
              color: Colors.grey[600]!,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventList(BuildContext context, List<QueryDocumentSnapshot> docs) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final eventData = docs[index].data() as Map<String, dynamic>;
        final event = EventHostingModal.fromMap(eventData);

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(event: event),
                ),
              );
            },
            child: _EventCard(event: event),
          ),
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventHostingModal event;

  const _EventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image with CachedNetworkImage
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: CachedNetworkImage(
              imageUrl: event.uploadedImageUrl ?? '',
              width: 160,
              height: 160,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(
                  width: 160,
                  height: 160,
                  color: Colors.grey[800],
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 160,
                height: 160,
                color: Colors.grey[900],
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.white54,
                  size: 40,
                ),
              ),
            ),
          ),

          // Event Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventName ?? 'Untitled Event',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),

                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    text: event.date != null
                        ? '${event.date!.day}/${event.date!.month}/${event.date!.year}'
                        : 'No Date',
                  ),

                  if (event.time != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: _buildInfoRow(
                        icon: Icons.access_time,
                        text: event.time!.format(context),
                      ),
                    ),

                  if (event.location != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: _buildInfoRow(
                        icon: Icons.location_on,
                        text: event.location!,
                      ),
                    ),

                  Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.ticketPrice != null
                            ? '₹${event.ticketPrice!.toStringAsFixed(2)}'
                            : 'Free',
                        style: TextStyle(
                          color: purple,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (event.seatAvailabilityCount != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: purple.withOpacity(0.5)),
                          ),
                          child: Text(
                            '${event.seatAvailabilityCount!.toInt()} seats',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
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

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: purple, size: 16),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white70),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
