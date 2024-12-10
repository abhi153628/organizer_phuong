import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';

class FirebaseEventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? eventId ;
  //! ID
  final String _eventCollection = 'eventCollection';
//! UPLOADING THE EVENT 
 Future<void> saveEvent(EventHostingModal event, {File? image}) async {
  try {
    // Create a new event reference (doc) in Firestore
    final eventRef = _firestore.collection(_eventCollection).doc();

    // Convert event object to a Map and add the event ID
    final eventData = event.toMap();
    eventData['eventId'] = eventRef.id;

    // If an image is provided, upload it to Firebase Storage with the event ID as the file name
    if (image != null) {
      // Change here: use eventRef.id as the filename in Firebase Storage
      final storageRef = _storage.ref('event_images/${eventRef.id}.jpg');
      
      // Upload the image
      await storageRef.putFile(image);
      
      // Get the download URL of the uploaded image
      final downloadUrl = await storageRef.getDownloadURL();
      
      // Add the image URL to the event data
      eventData['uploadedImageUrl'] = downloadUrl;
    }

    // Save the event data (including event ID and image URL) to Firestore
    await eventRef.set(eventData);
  } on FirebaseException catch (e) {
    print('Error saving event: $e');
    rethrow;
  } catch (e) {
    print('Unexpected error: $e');
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
}
