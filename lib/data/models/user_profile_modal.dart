import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? phoneNumber;
  final Timestamp? createdAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.phoneNumber,
    this.createdAt,
  });

  // Convert Firestore document to UserProfile object
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      phoneNumber: data['phoneNumber'],
      createdAt: data['createdAt'],
    );
  }

  // Convert UserProfile to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
    };
  }

  // Optional: Add validation methods
  bool isProfileComplete() {
    return name.isNotEmpty && email.isNotEmpty;
  }
}

class OrganizerProfile {
  final String id;
  final String name;
  final String email;
  final String? organizationName;
  final String? profileImageUrl;
  final String? phoneNumber;
  final Timestamp? createdAt;

  OrganizerProfile({
    required this.id,
    required this.name,
    required this.email,
    this.organizationName,
    this.profileImageUrl,
    this.phoneNumber,
    this.createdAt,
  });

  // Convert Firestore document to OrganizerProfile object
  factory OrganizerProfile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return OrganizerProfile(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      organizationName: data['organizationName'],
      profileImageUrl: data['profileImageUrl'],
      phoneNumber: data['phoneNumber'],
      createdAt: data['createdAt'],
    );
  }

  // Convert OrganizerProfile to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'organizationName': organizationName,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
    };
  }

  // Optional: Add validation methods
  bool isProfileComplete() {
    return name.isNotEmpty && email.isNotEmpty && organizationName != null;
  }
}