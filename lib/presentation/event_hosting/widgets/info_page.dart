// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';

class EventHostingInfoPage extends StatelessWidget {
  const EventHostingInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Phuong Hosting Guidelines',
          style: TextStyle(
            fontFamily: 'IBMPlexSans',
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isLargeScreen ? 32.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Event Verification',
              'All events must be genuine and accurately represented. False information or misleading details will result in immediate account termination.',
              Icons.verified_user,
              isLargeScreen,
            ),
            _buildDivider(),
            _buildSection(
              'User Trust & Safety',
              'As an event organizer, you are responsible for delivering the promised experience. Maintain clear communication with attendees and ensure their safety during events.',
              Icons.security,
              isLargeScreen,
            ),
            _buildDivider(),
            _buildSection(
              'Cancellation Policy',
              'Event cancellations must be communicated immediately. Full compensation is required for cancelled events with existing bookings. Multiple cancellations may affect your hosting privileges.',
              Icons.event_busy,
              isLargeScreen,
            ),
            _buildDivider(),
            _buildSection(
              'Revenue & Payments',
              'Track your event revenue through the dashboard. Payments are processed securely and transferred after successful event completion.',
              Icons.payments,
              isLargeScreen,
            ),
            _buildDivider(),
            _buildSection(
              'Content Guidelines',
              'Provide accurate event details, clear images, and honest descriptions. Misrepresentation or inappropriate content will result in removal.',
              Icons.content_paste,
              isLargeScreen,
            ),
            _buildDivider(),
            _buildSection(
              'Legal Compliance',
              'Events must comply with local laws and regulations. Phuong reserves the right to remove events or suspend accounts involved in illegal activities.',
              Icons.gavel,
              isLargeScreen,
            ),
            SizedBox(height: 32),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
               
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 32 : 24,
                    vertical: isLargeScreen ? 16 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'I Understand',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: isLargeScreen ? 16 : 14,
                    fontWeight: FontWeight.w500,
                    color: white

                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon, bool isLargeScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: purple, size: isLargeScreen ? 28 : 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'IBMPlexSans',
                    fontSize: isLargeScreen ? 20 : 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: isLargeScreen ? 16 : 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.1),
      thickness: 1,
      height: 1,
    );
  }
}