import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';

class FirebaseEventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
   final OrganizerProfileAddingFirebaseService _organizerService = OrganizerProfileAddingFirebaseService();
  String? eventId ;
  //! ID
  final String _eventCollection = 'eventCollection';
//! UPLOADING THE EVENT 
  Future<void> saveEvent(EventHostingModal event, {File? image}) async {
    try {
      final organizerId = await getCurrentOrganizerId();
      if (organizerId == null) {
        throw Exception('No organizer ID found');
      }

      final eventRef = _firestore.collection(_eventCollection).doc();
      final eventData = event.toMap();
      eventData['eventId'] = eventRef.id;
      eventData['organizerId'] = organizerId; // Add organizer ID

      if (image != null) {
        final storageRef = _storage.ref('event_images/${eventRef.id}.jpg');
        await storageRef.putFile(image);
        final downloadUrl = await storageRef.getDownloadURL();
        eventData['uploadedImageUrl'] = downloadUrl;
      }

      await eventRef.set(eventData);
    } catch (e) {
      print('Error saving event: $e');
      rethrow;
    }
  }


  Future<List<EventHostingModal>> getEvents() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      return snapshot.docs
      //!here changes
          .map((doc) => EventHostingModal.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      print('Error getting events: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }
   Future<void> updateEvent(EventHostingModal event, {File? image}) async {
    try {
      if (event.eventId == null) {
        throw Exception('Event ID is required for updating');
      }

      // Get reference to the existing event document
      final eventRef = _firestore.collection(_eventCollection).doc(event.eventId);

      // Convert event object to a Map
      final eventData = event.toMap();

      // If a new image is provided, upload it
      if (image != null) {
        final storageRef = _storage.ref('event_images/${event.eventId}.jpg');
        await storageRef.putFile(image);
        final downloadUrl = await storageRef.getDownloadURL();
        eventData['uploadedImageUrl'] = downloadUrl;
      }

      // Update the event data in Firestore
      await eventRef.update(eventData);
    } on FirebaseException catch (e) {
      print('Error updating event: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }

  
    Future<void> deleteEvent(String eventId) async {
    try {
      // Check if eventId is provided
      if (eventId.isEmpty) {
        throw Exception('Event ID is required for deletion');
      }

      // Reference to the event document
      final eventRef = _firestore.collection(_eventCollection).doc(eventId);

      // Get the event document to check if it exists and to retrieve image URL
      final eventDoc = await eventRef.get();
      if (!eventDoc.exists) {
        throw Exception('Event not found');
      }

      // Delete the image from Firebase Storage if it exists
      final eventData = eventDoc.data();
      if (eventData != null && eventData.containsKey('uploadedImageUrl')) {
        final storageRef = _storage.ref('event_images/$eventId.jpg');
        await storageRef.delete();
      }

      // Delete the event document from Firestore
      await eventRef.delete();

      print('Event deleted successfully: $eventId');
    } on FirebaseException catch (e) {
      print('Firebase error deleting event: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error deleting event: $e');
      rethrow;
    }
  }
    Future<String?> getCurrentOrganizerId() async {
    try {
      final profile = await _organizerService.getCurrentUserProfile();
      return profile?.id;
    } catch (e) {
      print('Error getting organizer ID: $e');
      return null;
    }
  }

  Stream<QuerySnapshot> getOrganizerEvents() async* {
    try {
      final organizerId = await getCurrentOrganizerId();
      if (organizerId == null) {
        throw Exception('No organizer ID found');
      }

      yield* _firestore
          .collection(_eventCollection)
          .where('organizerId', isEqualTo: organizerId)
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      print('Error in getOrganizerEvents: $e');
      rethrow;
    }
  }
}
