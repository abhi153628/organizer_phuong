import 'package:cloud_firestore/cloud_firestore.dart';

class EventDeletionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if event has any bookings
  Future<bool> hasActiveBookings(String eventId) async {
    final bookings = await _firestore
        .collection('userBookings')
        .where('eventId', isEqualTo: eventId)
        .get();
    
    return bookings.docs.isNotEmpty;
  }

  // Create notification for user
  Future<void> createUserNotification(String userId, String eventName) async {
    await _firestore.collection('userNotifications').add({
      'userId': userId,
      'title': 'Event Cancelled',
      'message': 'The event "$eventName" has been cancelled by the organizer. A refund will be processed if applicable.',
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'type': 'event_cancellation'
    });
  }

  // Update booking status and notify users
  Future<void> handleEventDeletion(String eventId, String eventName) async {
    // Get all bookings for this event
    final bookings = await _firestore
        .collection('userBookings')
        .where('eventId', isEqualTo: eventId)
        .get();

    // If there are bookings, update their status and notify users
    for (var booking in bookings.docs) {
      final userId = booking.data()['userId'];
      
      // Update booking status
      await booking.reference.update({
        'status': 'cancelled',
        'cancellationDate': FieldValue.serverTimestamp(),
        'cancellationReason': 'Event cancelled by organizer'
      });

      // Create notification for the user
      await createUserNotification(userId, eventName);
    }
  }
}