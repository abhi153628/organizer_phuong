import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';
import 'package:phuong_for_organizer/presentation/edit_page_event_hosting/edit_page_event.dart';
import 'package:phuong_for_organizer/presentation/event_detailed_page/widgets/delete_bottom_sheet.dart';
import 'package:phuong_for_organizer/presentation/event_detailed_page/widgets/menu_button_widget.dart';
import 'package:shimmer/shimmer.dart';

class EventDetailPage extends StatefulWidget {
  final EventHostingModal event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showEventNameInAppBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollPosition = _scrollController.offset;
    final showEventName = scrollPosition > 400;
    
    if (showEventName != _showEventNameInAppBar) {
      setState(() {
        _showEventNameInAppBar = showEventName;
      });
    }
  }

  void _showDeleteConfirmation(String eventId) async {
    bool? result = await EventDeleteBottomSheet.show(context, eventId);

    if (result == true) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 500,
              floating: false,
              pinned: true,
              backgroundColor: Colors.black.withOpacity(0.8),
              title: _showEventNameInAppBar 
                ? Text(
                    widget.event.eventName ?? 'Untitled Event', 
                    style: GoogleFonts.ibmPlexSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ) 
                : null,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildEventHeaderImage(),
              ),
              actions: [
                MenuButton(
                  context,
                  onEdit: () => Navigator.of(context).push(
                    GentlePageTransition(
                      page: EditEventPage(event: widget.event)
                    )
                  ),
                  onDelete: () => _showDeleteConfirmation(widget.event.eventId!),
                ),
              ],
            ),
          ];
        },
        body: _buildEventContent(context),
      ),
    );
  }

 Widget _buildEventHeaderImage() {
  return Hero(
    tag: 'event-image-${widget.event.eventId}',
    child: Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: widget.event.uploadedImageUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildImagePlaceholder(),
          errorWidget: (context, url, error) => _buildImageError(),
        ),
        _buildGradientOverlay(),
        Positioned(
          top: 480,
          left: 20,
          child: Text(
            widget.event.eventName ?? 'Untitled Event',
            style: GoogleFonts.ibmPlexSans(
              color: Colors.white,
              fontSize: 28,
              letterSpacing: 0.9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

//! I M A G E   WITH  S H I M M E R  E F F E C T
Widget _buildImagePlaceholder() {
    return Shimmer.fromColors(
      baseColor: purple,
      highlightColor: purple.withOpacity(0.4),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              purple.withOpacity(0.6),
            purple.withOpacity(0.6),
          purple.withOpacity(0.6),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                color: Colors.white.withOpacity(0.5),
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading Event Image',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildImageError() {
  return Center(
    child: Icon(
      Icons.broken_image,
      color: Colors.white54,
      size: 50,
    ),
  );
}


  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.4),
            Colors.black,
          ],
        ),
      ),
    );
  }

  Widget _buildEventContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventDetailsSection(),
            const SizedBox(height: 20),
            _buildTicketInformationSection(),
            const SizedBox(height: 20),
            _buildDescriptionSection(),
            if (widget.event.eventRules?.isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              _buildEventRulesSection(),
            ],
            const SizedBox(height: 20),
            _buildContactInformationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetailsSection() {
    return _buildInfoSection(
      title: 'Event Details',
      children: [
        _buildLabeledInfoRow(
          icon: Icons.calendar_today,
          label: 'Date',
          text: _formatDate(widget.event.date),
        ),
        _buildLabeledInfoRow(
          icon: Icons.access_time,
          label: 'Time',
          text: widget.event.time?.format(context) ?? 'Time not specified',
        ),
        _buildLabeledInfoRow(
          icon: Icons.location_on,
          label: 'Location',
          text: widget.event.location ?? 'Location not specified',
        ),
        _buildLabeledInfoRow(
          icon: Icons.timer,
          label: 'Duration',
          text: '${widget.event.eventDurationTime} hours',
        ),
      ],
    );
  }

  Widget _buildTicketInformationSection() {
    return _buildInfoSection(
      title: 'Ticket Information',
      children: [
        _buildLabeledInfoRow(
          icon: Icons.confirmation_number,
          label: 'Price',
          text: '₹${widget.event.ticketPrice?.toStringAsFixed(2) ?? "Free"}',
        ),
        _buildLabeledInfoRow(
          icon: Icons.event_seat,
          label: 'Availability',
          text: '${widget.event.seatAvailabilityCount?.toInt() ?? 0} seats available',
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return _buildInfoSection(
      title: 'Description',
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            widget.event.description ?? 'No description available',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventRulesSection() {
    return _buildInfoSection(
      title: 'Event Rules',
      children: widget.event.eventRules!.map((rule) => 
        _buildLabeledInfoRow(
          icon: Icons.check_circle_outline,
          label: 'Rule',
          text: rule,
        )
      ).toList(),
    );
  }

  Widget _buildContactInformationSection() {
    return _buildInfoSection(
      title: 'Contact Information',
      children: [
        if (widget.event.email != null)
          _buildLabeledInfoRow(
            icon: Icons.email,
            label: 'Email',
            text: widget.event.email!,
          ),
        if (widget.event.instagramLink != null)
          _buildLabeledInfoRow(
            icon: Icons.camera_alt,
            label: 'Instagram',
            text: 'Instagram',
            onTap: () => _launchURL(widget.event.instagramLink!),
          ),
        if (widget.event.facebookLink != null)
          _buildLabeledInfoRow(
            icon: Icons.facebook,
            label: 'Facebook',
            text: 'Facebook',
            onTap: () => _launchURL(widget.event.facebookLink!),
          ),
      ],
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: purple.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabeledInfoRow({
    required IconData icon,
    required String label,
    required String text,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: purple, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: purple.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
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

  void _launchURL(String url) async {
    // TODO: Implement URL launching using url_launcher package
  }
}