// lib/services/firebase_profile_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseProfileService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
 final String _organizersCollection = 'organizers';
  final String _profilesCollection = 'profiles';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

      final docRef =
          _firestore.collection(_organizersCollection).doc(organizerId);

      await docRef.set(profileData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save profile data: $e');
    }
  }

//!fetching data
  Future<Map<String, dynamic>> getProfileData(String organizerId) async {
    try {
      final docSnapshot = await _firestore
          .collection(_organizersCollection)
          .doc(organizerId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data() ?? {};
      } else {
        throw Exception('Profile not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile data: $e');
    }
  }
 Future<List<Map<String, dynamic>>> getPendingBands() async {
    try {
      final querySnapshot = await _firestore
          .collection(_organizersCollection)
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch pending bands: $e');
    }
  }

  Future<void> updateBandStatus(String organizerId, String status) async {
    try {
      await _firestore
          .collection(_organizersCollection)
          .doc(organizerId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update band status: $e');
    }
  }
}

