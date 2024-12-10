import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class PostFeedFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Upload image to Firebase Storage
  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = const Uuid().v4();
      Reference ref = _storage.ref().child('post_images/$fileName.jpg');
      UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Image upload error: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  // Create a new post and add it to the posts array
  Future<void> createPost({
    required File imageFile,
    String? description,
  }) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Validate image
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      // Upload image
      final String imageUrl = await uploadImage(imageFile);

      // Find the organizer document
      var query = _firestore
          .collection('organizers')
          .where('email', isEqualTo: currentUser.email);
      var querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No organizer document found');
      }

      String organizerId = querySnapshot.docs.first.id;

      // Create a new post object
      Map<String, dynamic> newPost = {
        'id': const Uuid().v4(), // Generate a unique ID for the post
        'imageUrl': imageUrl,
        'description': description?.trim() ?? '',
        'timestamp': DateTime.now().toIso8601String(), // Use DateTime instead of FieldValue
        'likes': 0,
      };

      // Use arrayUnion to add the new post
      await _firestore.collection('organizers').doc(organizerId).update({
        'posts': FieldValue.arrayUnion([newPost])
      });
    } catch (e) {
      print('Post creation error: $e');
      rethrow;
    }
  }

  // Fetch all posts for the current user
  Stream<List<Map<String, dynamic>>> fetchUserPosts() {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('organizers')
        .where('email', isEqualTo: currentUser.email)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      }

      var organizerData = snapshot.docs.first.data();
      var posts = organizerData['posts'] as List<dynamic>? ?? [];

      // Convert posts to the required format
      return posts.map((post) => Map<String, dynamic>.from(post)).toList();
    });
  }

  // Delete a specific post
  Future<void> deletePost(String postId) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Find the organizer document
      var query = _firestore
          .collection('organizers')
          .where('email', isEqualTo: currentUser.email);
      var querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No organizer document found');
      }

      String organizerId = querySnapshot.docs.first.id;
      var organizerData = querySnapshot.docs.first.data();

      // Find the specific post to delete
      List posts = organizerData['posts'] ?? [];
      var postToDelete = posts.firstWhere(
        (post) => post['id'] == postId,
        orElse: () => null,
      );

      if (postToDelete == null) {
        throw Exception('Post not found');
      }

      // Delete image from storage
      if (postToDelete['imageUrl'] != null) {
        try {
          final imageRef = _storage.refFromURL(postToDelete['imageUrl']);
          await imageRef.delete();
        } catch (e) {
          print('Error deleting image from storage: $e');
        }
      }

      // Remove the specific post from the array
      await _firestore.collection('organizers').doc(organizerId).update({
        'posts': FieldValue.arrayRemove([postToDelete])
      });
    } catch (e) {
      print('Post deletion error: $e');
      rethrow;
    }
  }
}