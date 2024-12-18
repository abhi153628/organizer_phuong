import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';
import 'package:uuid/uuid.dart';

class OrganizerProfileAddingFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; 
  final FirebaseStorage _storage = FirebaseStorage.instance;

 
 final String _collection = 'organizers';
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

  // Save profile data to Firestore
  Future<String> saveProfile(OrganizerProfileAddingModal profile) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('No authenticated user found');

      // Use email as query to get the organizer document
      var query = _firestore
          .collection(_collection)
          .where('email', isEqualTo: currentUser.email);

      var querySnapshot = await query.get();
      if (querySnapshot.docs.isEmpty) {
        throw Exception('No organizer document found');
      }

      String organizerId = querySnapshot.docs.first.id;

      // Update the existing document with profile information
      await _firestore.collection(_collection).doc(organizerId).update({
        'name': profile.name,
        'bio': profile.bio,
        'imageUrl': profile.imageUrl,
        'links': profile.links,
     
      });

      return organizerId;
    } catch (e) {
      throw Exception('Failed to save profile: $e');
    }
  }

  // Get current user's profile
  Future<OrganizerProfileAddingModal?> getCurrentUserProfile() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return null;

      var query = _firestore
          .collection(_collection)
          .where('email', isEqualTo: currentUser.email);

      var querySnapshot = await query.get();
      if (querySnapshot.docs.isEmpty) return null;

      Map<String, dynamic> data = querySnapshot.docs.first.data();
      data['id'] = querySnapshot.docs.first.id;
      return OrganizerProfileAddingModal.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }


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
