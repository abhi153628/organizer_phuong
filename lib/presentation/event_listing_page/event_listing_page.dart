import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/data/dataresources/event_hosting_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';
import 'package:phuong_for_organizer/presentation/event_detailed_page/event_detailed_page.dart';

class EventListPage extends StatelessWidget {
  final FirebaseEventService _eventService = FirebaseEventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: purple,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No events found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final eventData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
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
  },child: EventCard(event: event)),
              );
            },
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventHostingModal event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            purple.withOpacity(0.2),
            Colors.black.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: purple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            if (event.uploadedImageUrl != null)
              Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  event.uploadedImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: purple.withOpacity(0.1),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 140),
                  Text(
                    event.eventName ?? 'Untitled Event',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (event.date != null)
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: purple, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '${event.date!.day}/${event.date!.month}/${event.date!.year}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        if (event.time != null) ...[
                          SizedBox(width: 16),
                          Icon(Icons.access_time, color: purple, size: 16),
                          SizedBox(width: 8),
                          Text(
                            event.time!.format(context),
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ],
                    ),
                  SizedBox(height: 8),
                  if (event.location != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, color: purple, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.location!,
                            style: TextStyle(color: Colors.white70),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${event.ticketPrice?.toStringAsFixed(2) ?? "Free"}',
                        style: TextStyle(
                          color: purple,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (event.seatAvailabilityCount != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: purple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: purple),
                          ),
                          child: Text(
                            '${event.seatAvailabilityCount!.toInt()} seats left',
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
          ],
        ),
      ),
    );
  }
}