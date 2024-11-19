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
}
