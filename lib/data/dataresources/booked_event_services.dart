import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import '../models/booked_events_modal.dart';

class OrganizerBookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final OrganizerProfileAddingFirebaseService _organizerProfileService = OrganizerProfileAddingFirebaseService();

  // Fetch bookings for a specific organizer's events
 // In OrganizerBookingService

Stream<List<BookingModel>> getOrganizerEventBookings() async* {
  try {
    // Add more detailed logging
    final organizerProfile = await _organizerProfileService.getCurrentUserProfile();
      print('Organizer profile: $organizerProfile'); // Add this line

      if (organizerProfile == null) {
        print('Organizer not authenticated'); // Add this line
        throw Exception('Organizer not authenticated');
      }

 

    yield* _firestore
        .collection('userBookings')
        .where('organizerId', isEqualTo: organizerProfile.id)
        .orderBy('bookingTime', descending: true)
        .snapshots()
        .map((snapshot) {
          print('Fetched ${snapshot.docs.length} documents'); // Debug print
          return snapshot.docs
              .map((doc) {
                print('Document data: ${doc.data()}'); // Debug print each document
                return BookingModel.fromMap({...doc.data(), 'id': doc.id});
              })
              .toList();
        });
  } catch (e) {
    print('Detailed Error fetching organizer bookings: $e');
    yield [];
  }
}

  // Get total revenue for an organizer
Future<double> getOrganizerTotalRevenue() async {
  try {
    final organizerProfile = await _organizerProfileService.getCurrentUserProfile();
    print('Organizer profile: $organizerProfile');

    if (organizerProfile == null) return 0.0;

    final querySnapshot = await _firestore
        .collection('userBookings')
        .where('organizerId', isEqualTo: organizerProfile.id)
        .get();

    return querySnapshot.docs.fold<double>(0.0, (total, doc) {
      try {
        final bookingData = doc.data();
        final booking = BookingModel.fromMap(bookingData);
        return total + booking.totalPrice;
      } catch (e) {
        print('Error processing booking: $e');
        return total;
      }
      
    });
  } catch (e) {
    print('Error calculating total revenue: $e');
    return 0.0;
  }
}

  // Get total bookings count for an organizer
  Future<int> getOrganizerTotalBookings() async {
    try {
       final organizerProfile = await _organizerProfileService.getCurrentUserProfile();
      print('Organizer profile: $organizerProfile'); 
     
      if (organizerProfile == null) return 0;

      final querySnapshot = await _firestore
          .collection('userBookings')
          .where('organizerId', isEqualTo: organizerProfile.id)
          .get();

      return querySnapshot.docs.length; // Simply count the number of documents
    } catch (e) {
      print('Error calculating total bookings: $e');
      return 0;
    }
  }
}
