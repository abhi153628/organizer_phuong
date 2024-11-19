import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';
import 'package:uuid/uuid.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _collection = 'organizer_profiles';

  // Upload image to Firebase Storage
  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = const Uuid().v4();
      Reference ref = _storage.ref().child('profile_images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Save profile data to Firestore with explicit ID handling
  Future<String> saveProfile(OrganizerProfileAddingModal profile) async {
    try {
      // Create a new document reference with auto-generated ID
      DocumentReference docRef = _firestore.collection(_collection).doc();
      
      // Update the profile with the new ID
      final updatedProfile = OrganizerProfileAddingModal(
        id: docRef.id,
        name: profile.name,
        bio: profile.bio,
        imageUrl: profile.imageUrl,
        links: profile.links,
      );

      // Save the profile with the ID included
      await docRef.set(updatedProfile.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save profile: $e');
    }
  }

  // Get profile by ID
  Future<OrganizerProfileAddingModal?> getProfile(String id) async {
    try {
      DocumentSnapshot doc = 
          await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Include the document ID in the data
        data['id'] = doc.id;
        return OrganizerProfileAddingModal.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }
   //method to your FirebaseService class
Future<void> updateProfile(OrganizerProfileAddingModal profile) async {
  try {
    await _firestore.collection(_collection).doc(profile.id).update({
      'name': profile.name,
      'bio': profile.bio,
      'imageUrl': profile.imageUrl,
      'links': profile.links,
    });
  } catch (e) {
    throw Exception('Failed to update profile: $e');
  }
}
}