import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class PostFeedFirebaseServiceClass {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage(File imageFile) async {
    final String fileName =
        'post_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference storageRef = _storage.ref().child(fileName);
    final UploadTask uploadTask = storageRef.putFile(imageFile);

    final TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> createPost(File imageFile, String description) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final imageUrl = await uploadImage(imageFile);
    
    await _firestore.collection('posts').add({
      'imageUrl': imageUrl,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': user.uid,
      'userEmail': user.email,
    });
  }

  Stream<List<Map<String, dynamic>>> fetchPosts() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    // Remove the orderBy to avoid index issues
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  ...doc.data(),
                  'id': doc.id,
                })
            .toList());
  }
  Future<void> deletePost(String postId) async {
  try {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    // Get the post first to check ownership and get image URL
    final postDoc = await _firestore.collection('posts').doc(postId).get();
    if (!postDoc.exists) throw Exception('Post not found');

    final postData = postDoc.data();
    if (postData?['userId'] != user.uid) {
      throw Exception('Not authorized to delete this post');
    }

    // Delete the image from storage if it exists
    if (postData?['imageUrl'] != null) {
      try {
        final imageRef = _storage.refFromURL(postData!['imageUrl']);
        await imageRef.delete();
      } catch (e) {
        print('Error deleting image: $e');
        // Continue with post deletion even if image deletion fails
      }
    }

    // Delete the post document
    await _firestore.collection('posts').doc(postId).delete();
  } catch (e) {
    throw Exception('Failed to delete post: $e');
  }
}

}
