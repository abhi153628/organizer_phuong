// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/presentation/bottom_navbar.dart';
import 'package:phuong_for_organizer/presentation/event_listing_page/event_listing_bloc/bloc/event_listing_bloc.dart';
import 'package:phuong_for_organizer/presentation/event_listing_page/event_listing_bloc/bloc/event_listing_event.dart';
import 'package:phuong_for_organizer/presentation/event_listing_page/event_listing_bloc/bloc/event_listing_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:phuong_for_organizer/core/constants/color.dart';

import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';
import 'package:phuong_for_organizer/presentation/event_detailed_page/event_detailed_page.dart';




import 'package:flutter_bloc/flutter_bloc.dart';


class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // No need to create a new BlocProvider here since it's provided at app level
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              GentlePageTransition(page: MainScreen(organizerId: '')),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Events',
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
      ),
      body: BlocConsumer<EventListBloc, EventListState>(
        listener: (context, state) {
          if (state is EventListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is EventListInitial) {
            // Trigger load events when in initial state
            context.read<EventListBloc>().add(LoadEvents());
            return _buildLoadingState();
          }
          
          if (state is EventListLoading) {
            return _buildLoadingState();
          }
          
          if (state is EventListError) {
            return _buildErrorState();
          }
          
          if (state is EventListLoaded) {
            if (state.events.isEmpty) {
              return _buildEmptyState();
            }
            return _buildEventList(context, state.events);
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return const Center(
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
          const SizedBox(height: 16),
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
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
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

  Widget _buildEventList(BuildContext context, List<EventHostingModal> events) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Dismissible(
            key: Key(event.eventId ?? ''),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              if (event.eventId != null) {
                context.read<EventListBloc>().add(DeleteEvent(event.eventId!));
              }
            },
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: white.withOpacity(0.4),
          width: 2,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: event.uploadedImageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(
                        color: Colors.grey[800],
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                        size: 40,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(1),
                        ],
                        stops: const [0.7, 0.9, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventName ?? 'Untitled Event',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    text: event.date != null
                        ? '${event.date!.day}/${event.date!.month}/${event.date!.year}'
                        : 'No Date',
                  ),
                  if (event.time != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: _buildInfoRow(
                        icon: Icons.access_time,
                        text: event.time!.format(context),
                      ),
                    ),
                  if (event.location != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: _buildInfoRow(
                        icon: Icons.location_on,
                        text: event.location!,
                      ),
                    ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.ticketPrice != null
                            ? '₹${event.ticketPrice!.toStringAsFixed(2)}'
                            : 'Free',
                        style: TextStyle(
                          color: purple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (event.seatAvailabilityCount != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: purple.withOpacity(0.5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: purple.withOpacity(0.2),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            '${event.seatAvailabilityCount!.toInt()} seats',
                            style: const TextStyle(
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
        Icon(icon, color: white, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}