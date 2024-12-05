import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/data/dataresources/event_hosting_firebase_service.dart';


class EventDeleteBottomSheet {
  static Future<bool?> show(BuildContext context, String eventId) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Warning Icon
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: purple.withOpacity(0.2),
                ),
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.warning_rounded,
                  color: purple,
                  size: 60,
                ),
              ),
              
              SizedBox(height: 24),
              
              // Title
              Text(
                'Delete Event',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 16),
              
              // Subtitle
              Text(
                'Are you sure you want to delete this event? This action cannot be undone.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 32),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 16),
                  
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // Delete the event
                          await FirebaseEventService().deleteEvent(eventId);
                          
                          // Close the bottom sheet and return true
                          Navigator.of(context).pop(true);
                          
                          // Optional: Show a success snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Event deleted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          // Close the bottom sheet
                          Navigator.of(context).pop(false);
                          
                          // Show an error snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete event: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}