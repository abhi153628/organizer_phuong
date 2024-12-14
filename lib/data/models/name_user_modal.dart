// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class UserProfile {
//   final String userId;
//   final String name;

//   UserProfile({
//     required this.userId,
//     required this.name,
//   });

//   factory UserProfile.fromJson(Map<String, dynamic> json) {
//     return UserProfile(
//       userId: json['userId'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'name': name,
//     };
//   }
// }

// class UserProfileService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Fetch the current authenticated user ID
//   String get userId {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception('No authenticated user found');
//     }
//     return user.uid;
//   }

//   // Fetch a user profile by ID
//   Future<UserProfile?> getUserProfileById(String userId) async {
//     try {
//       debugPrint('Fetching user profile for ID: $userId');
//       final doc = await _firestore.collection('userProfiles').doc(userId).get();

//       if (!doc.exists) {
//         debugPrint('User profile with ID $userId does not exist in Firestore.');
//         return null;
//       }

//       final userProfile = UserProfile(
//         userId: userId,
//         name: doc.data()?['name'] ?? 'Unknown User',
//       );

//       debugPrint('Fetched user profile: ${userProfile.toJson()}');
//       return userProfile;
//     } catch (e) {
//       debugPrint('Error fetching user profile by ID: $e');
//       return null;
//     }
//   }

//   // Fetch the profile of the currently authenticated user
//   Future<UserProfile?> getCurrentUserProfile() async {
//     try {
//       final currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser == null) {
//         debugPrint('No authenticated user found.');
//         return null;
//       }

//       debugPrint('Fetching profile for current user: ${currentUser.uid}');
//       final userProfile = await getUserProfileById(currentUser.uid);

//       if (userProfile != null) {
//         debugPrint('Current user profile details: ${userProfile.toJson()}');
//       } else {
//         debugPrint('No profile found for current user.');
//       }

//       return userProfile;
//     } catch (e) {
//       debugPrint('Error fetching current user profile: $e');
//       return null;
//     }
//   }
// }
