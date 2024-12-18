// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:phuong_for_organizer/data/models/booked_events_modal.dart';


// class OrganizerBookingService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Fetch bookings for a specific organizer's events
//   Stream<List<BookingModel>> getOrganizerEventBookings(String organizerId) {
//     return _firestore
//         .collection('userBookings')
//         .where('organizerId', isEqualTo: organizerId)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => BookingModel.fromMap(doc.data()))
//             .toList());
//   }

//   // Get total revenue for an organizer
//   Future<double> getOrganizerTotalRevenue(String organizerId) async {
//     final querySnapshot = await _firestore
//         .collection('userBookings')
//         .where('organizerId', isEqualTo: organizerId)
//         .get();

//     return querySnapshot.docs.fold(0.0, (total, doc) {
//       final booking = BookingModel.fromMap(doc.data());
//       return total + booking.totalPrice;
//     });
//   }

//   // Get total bookings count for an organizer
//   Future<int> getOrganizerTotalBookings(String organizerId) async {
//     final querySnapshot = await _firestore
//         .collection('userBookings')
//         .where('organizerId', isEqualTo: organizerId)
//         .get();

//     return querySnapshot.docs.fold(0, (total, doc) {
//       final booking = BookingModel.fromMap(doc.data());
//       return total + booking.seatsBooked;
//     });
//   }

//   // Fetch bookings for a specific event of an organizer
//   Stream<List<BookingModel>> getSpecificEventBookings(
//       String organizerId, String eventId) {
//     return _firestore
//         .collection('userBookings')
//         .where('organizerId', isEqualTo: organizerId)
//         .where('eventId', isEqualTo: eventId)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => BookingModel.fromMap(doc.data()))
//             .toList());
//   }

//   // Export bookings to CSV (Optional utility method)
//   Future<String> exportBookingsToCSV(String organizerId) async {
//     final bookings = await getOrganizerEventBookings(organizerId).first;
    
//     // Create CSV header
//     String csv = 'Booking ID,Event Name,User Name,Seats Booked,Total Price,Booking Time,User Email,User Phone\n';
    
//     // Add booking data
//     for (var booking in bookings) {
//       csv += '${booking.bookingId},'
//              '${booking.eventName},'
//              '${booking.userName},'
//              '${booking.seatsBooked},'
//              '${booking.totalPrice},'
//              '${booking.bookingTime},'
//              '${booking.userEmail},'
//              '${booking.userPhone}\n';
//     }
    
//     return csv;
//   }
// }