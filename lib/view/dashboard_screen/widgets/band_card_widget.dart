import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:testing/utils/cstm_alertbox.dart';
import 'package:testing/view/profile_screen/profile_view_screen.dart';

class BandCard extends StatefulWidget {
  final Map<String, dynamic> bandData;
  final Function(String, String) onStatusUpdate;
  final bool showAcceptButton;
  final bool showRejectButton;

  const BandCard({
    Key? key,
    required this.bandData,
    required this.onStatusUpdate,
    this.showAcceptButton = true,
    this.showRejectButton = true,
  }) : super(key: key);

  @override
  State<BandCard> createState() => _BandCardState();
}

class _BandCardState extends State<BandCard> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Enhanced responsive breakpoints
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 1200;
    final isLargeScreen = screenWidth >= 1200;

    // Responsive padding calculations
    final double horizontalPadding = isSmallScreen ? 12 : (isMediumScreen ? 16 : 20);
    final double verticalPadding = isSmallScreen ? 8 : (isMediumScreen ? 12 : 16);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: Card(
        elevation: isHovering ? 8 : 2,
        color: isHovering ? const Color(0xFF333333) : const Color(0xFF222222),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: isSmallScreen ? 4 : 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: InkWell(
                  onTap: () => _showProfileDialog(context),
                  child: _buildBandImage(widget.bandData['imageUrl']),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: _buildCardContent(context, isSmallScreen, isMediumScreen, isLargeScreen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, bool isSmallScreen, bool isMediumScreen, bool isLargeScreen) {
    // Responsive font sizes
    final double titleFontSize = isSmallScreen ? 18 : (isMediumScreen ? 24 : 30);
    final double subtitleFontSize = isSmallScreen ? 14 : (isMediumScreen ? 20 : 24);
    final double buttonFontSize = isSmallScreen ? 13 : (isMediumScreen ? 18 : 22);

    // Responsive spacing
    final double verticalSpacing = isSmallScreen ? 6 : (isMediumScreen ? 10 : 14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          (widget.bandData['name'] ?? '').toUpperCase(),
          style: GoogleFonts.ibmPlexSansArabic(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 3),
        Row(
          children: [
            const Icon(Icons.music_note, color: Color(0xFFFF5E1D)),
            Expanded(
              child: Text(
                '${_getEventType(widget.bandData['eventType'])} ',
                style: GoogleFonts.rubik(
                  color: const Color.fromARGB(255, 188, 186, 186),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 3),
        _buildActionButtons(
          context, 
          buttonHeight: isSmallScreen ?  30: (isMediumScreen ? 40 : 50),
          fontSize: buttonFontSize,
          spacing: isSmallScreen ? 8 : 12,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, {
    required double buttonHeight,
    required double fontSize,
    required double spacing,
  }) {
    return Row(
      children: [
        if (widget.showAcceptButton)
          Expanded(
            child: SizedBox(
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFFF5E1D).withOpacity(0.8),
                ),
                onPressed: () => _showConfirmationDialog(
                  context,
                  'accept',
                  'Are you sure you want to accept this event organizer?',
                ),
                child: Text(
                  'Approve',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),

                ),
              ),
            ),
          ),
        if (widget.showAcceptButton && widget.showRejectButton)
          SizedBox(width: spacing),
        if (widget.showRejectButton)
          Expanded(
            child: SizedBox(
              height:30,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                onPressed: () => _showConfirmationDialog(
                  context,
                  'reject',
                  'Are you sure you want to reject this event organizer?',
                ),
                child: Text(
                  'Reject',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, String action, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Final Confirmation',
          subtitle: message,
          confirmButtonText: 'Yes, Confirm',
          cancelButtonText: 'Review Again',
          onConfirm: () {
            widget.onStatusUpdate(
              widget.bandData['organizerId'],
              action == 'accept' ? 'approved' : 'rejected',
            );
            Navigator.of(context).pop();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void _showProfileDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth < 600 ? screenWidth * 0.9 : 
                       screenWidth < 1200 ? screenWidth * 0.8 : 
                       screenWidth * 0.7;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: ProfilePage(
            organizerId: widget.bandData['organizerId'],
            width: dialogWidth,
            onStatusUpdate: widget.onStatusUpdate,
            key: ValueKey('profile_page_${widget.bandData['organizerId']}'),
          ),
        );
      },
    );
  }
}

Widget _buildBandImage(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return _buildFallbackImage();
  }

  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => Center(
      child: SizedBox(
        height: 100,
        width: 100,
      ),
    ),
    errorWidget: (context, url, error) => _buildFallbackImage(),
  );
}

Widget _buildFallbackImage() {
  return Image.asset(
    'asset/william-recinos-qtYhAQnIwSE-unsplash.jpg',
    fit: BoxFit.cover,
  );
}

String _getEventType(int? eventType) {
  switch (eventType) {
    case 0:
      return 'Soloist';
    case 1:
      return 'Ensemble';
    default:
      return 'Unknown Event Type';
  }
}