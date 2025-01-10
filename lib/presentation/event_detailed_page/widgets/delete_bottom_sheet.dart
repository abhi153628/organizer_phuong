// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/data/dataresources/deletion_event_service.dart';
import 'package:phuong_for_organizer/data/dataresources/event_hosting_firebase_service.dart';

class EventDeleteBottomSheet {
  static Future<bool?> show(
      BuildContext context, String eventId, String eventName) {
    final EventDeletionService _deletionService = EventDeletionService();

    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
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
                      FutureBuilder<bool>(
                        future: _deletionService.hasActiveBookings(eventId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(purple),
                              ),
                            );
                          }

                          if (snapshot.hasData && snapshot.data == true) {
                            bool _notifyUsers = false;
                            bool _refundTickets = false;
                            bool _isDeleting = false;

                            return StatefulBuilder(
                              builder: (context, setInnerState) {
                                return Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Active Bookings Detected',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'This event has existing ticket holders. Please review the following options carefully.',
                                            style: TextStyle(
                                              color: Colors.red.withOpacity(0.8),
                                              fontSize: 14,
                                              height: 1.5,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    CheckboxListTile(
                                      value: _notifyUsers,
                                      onChanged: _isDeleting
                                          ? null
                                          : (value) {
                                              setInnerState(() =>
                                                  _notifyUsers = value ?? false);
                                            },
                                      title: Text(
                                        'Send Cancellation Notifications',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Automatically notify all ticket holders via email and in-app notification about the event cancellation',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                      checkColor: Colors.black,
                                      activeColor: purple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    CheckboxListTile(
                                      value: _refundTickets,
                                      onChanged: _isDeleting
                                          ? null
                                          : (value) {
                                              setInnerState(() =>
                                                  _refundTickets = value ?? false);
                                            },
                                      title: Text(
                                        'Issue Compensation Vouchers',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Provide affected ticket holders with compensation vouchers for future events',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                      checkColor: Colors.black,
                                      activeColor: purple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    SizedBox(height: 32),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _isDeleting
                                                ? null
                                                : () =>
                                                    Navigator.of(context).pop(false),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[900],
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: Text('Cancel'),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: (_notifyUsers &&
                                                    _refundTickets &&
                                                    !_isDeleting)
                                                ? () async {
                                                    setInnerState(
                                                        () => _isDeleting = true);
                                                    try {
                                                      await _deletionService
                                                          .handleEventDeletion(
                                                              eventId, );
                                                      await FirebaseEventService()
                                                          .deleteEvent(eventId);
                                                      Navigator.of(context)
                                                          .pop(true);
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Event deleted and users notified'),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );
                                                    } catch (e) {
                                                      setInnerState(
                                                          () => _isDeleting = false);
                                                      Navigator.of(context)
                                                          .pop(false);
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Failed to delete event: ${e.toString()}'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: purple,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: _isDeleting
                                                ? SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(Colors.white),
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : Text('Delete'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          bool _isDeleting = false;

                          return StatefulBuilder(
                            builder: (context, setInnerState) {
                              return Column(
                                children: [
                                  Text(
                                    'Are you sure you want to delete this event? This action cannot be undone.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 32),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _isDeleting
                                              ? null
                                              : () =>
                                                  Navigator.of(context).pop(false),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[900],
                                            padding:
                                                EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: Text('Cancel'),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _isDeleting
                                              ? null
                                              : () async {
                                                  setInnerState(
                                                      () => _isDeleting = true);
                                                  try {
                                                    await _deletionService
                                                        .handleEventDeletion(
                                                            eventId, );
                                                    await FirebaseEventService()
                                                        .deleteEvent(eventId);
                                                    Navigator.of(context).pop(true);
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Event deleted and users notified'),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    );
                                                  } catch (e) {
                                                    setInnerState(
                                                        () => _isDeleting = false);
                                                    Navigator.of(context)
                                                        .pop(false);
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Failed to delete event: ${e.toString()}'),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: purple,
                                            padding:
                                                EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: _isDeleting
                                              ? SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(Colors.white),
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : Text('Delete'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
      },
    );
  }
}