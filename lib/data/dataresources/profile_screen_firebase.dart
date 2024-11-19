// lib/services/firebase_profile_service.dart
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseProfileService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _organizersCollection = 'organizers';


  // Save profile data to Firestore
  Future<void> saveProfileData({
    required String organizerId,
    required String name,
    required String description,
    required String phoneNumber,
    required String email,
    required String location,
    required int eventType,
    String? imageUrl,
  }) async {
    try {
      // Validate required fields
      if (name.isEmpty ||
          description.isEmpty ||
          phoneNumber.isEmpty ||
          email.isEmpty ||
          location.isEmpty) {
        throw Exception('All fields are required');
      }

      final profileData = {
        'organizerId': organizerId,
        'name': name,
        'description': description,
        'phoneNumber': phoneNumber,
        'email': email,
        'location': location,
        'eventType': eventType,
        'imageUrl': imageUrl,
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = _firestore
          .collection(_organizersCollection)
          .doc(organizerId);

      await docRef.set(profileData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save profile data: $e');
    }
  }

  //store in fireStorage
  Future<String> addProfileImage(String path, String fileName) async {
    try {
      File file = File(path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to Firebase Storage
      Reference ref = _storage.ref().child('images/$fileName.jpg');

      // Upload the file
      UploadTask uploadTask = ref.putFile(file);
      // uploadTask.snapshotEvents.listen(
      //   (event) {
      //     log(event.bytesTransferred.toString());
      //   },
      // );
      // Wait for the upload to complete and get the download URL
      TaskSnapshot snapshot = await uploadTask;
    log('image  uploaded');
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      log(e.code);
      rethrow;
    }
  }

  // Update profile data with proper validation
 Future<void> updateProfileImage(String organizerId, String newImageUrl) async {
  try {
    await FirebaseFirestore.instance
        .collection('organizers')
        .doc(organizerId)
        .update({
      'imageUrl': newImageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error updating profile image: $e');
    throw e;
  }
}}
