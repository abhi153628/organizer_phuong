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

  // Create notification for user with enhanced booking information
  Future<void> createUserNotification({
    required String userId,
    required String eventName,
    required String bookingId,
    required int seatsBooked,
    required double totalAmount,
  }) async {
    await _firestore.collection('userNotifications').add({
      'userId': userId,
      'title': 'Event Cancelled',
      'message': 'The event "$eventName" has been cancelled by the organizer. A refund will be processed if applicable.',
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'type': 'event_cancellation',
      // Additional booking information
      'bookingId': bookingId,
      'eventName': eventName,
      'seatsBooked': seatsBooked,
      'totalAmount': totalAmount,
    });
  }

  // Update booking status and notify users
  Future<void> handleEventDeletion(String eventId) async {
    try {
      // First, get the event name from any booking for this event
      final bookings = await _firestore
          .collection('userBookings')
          .where('eventId', isEqualTo: eventId)
          .get();

      if (bookings.docs.isEmpty) {
        print('No bookings found for event $eventId');
        return;
      }

      // If there are bookings, update their status and notify users
      for (var booking in bookings.docs) {
        final bookingData = booking.data();
        final userId = bookingData['userId'];
        final bookingId = booking.id;
        final seatsBooked = bookingData['seatsBooked'] ?? 0;
        final totalAmount = (bookingData['totalPrice'] is num)
            ? (bookingData['totalPrice'] as num).toDouble()
            : 0.0;
        // Get event name from booking data
        final eventName = bookingData['eventName'] as String? ?? 'Unknown Event';

        // Update booking status
        await booking.reference.update({
          'status': 'cancelled',
          'cancellationDate': FieldValue.serverTimestamp(),
          'cancellationReason': 'Event cancelled by organizer'
        });

        // Create notification for the user with enhanced information
        await createUserNotification(
          userId: userId,
          eventName: eventName,  // Using event name from booking data
          bookingId: bookingId,
          seatsBooked: seatsBooked,
          totalAmount: totalAmount,
        );
      }
    } catch (e) {
      print('Error in handleEventDeletion: $e');
      throw e;
    }
  }
}