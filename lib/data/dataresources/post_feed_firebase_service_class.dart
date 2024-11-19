import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class PostFeedFirebaseServiceClass {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File imageFile) async {
    final String fileName = 'post_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference storageRef = _storage.ref().child(fileName);
    final UploadTask uploadTask = storageRef.putFile(imageFile);

    final TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> createPost(File imageFile, String description) async {
    final imageUrl = await uploadImage(imageFile);
    await _firestore.collection('posts').add({
      'imageUrl': imageUrl,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> fetchPosts() {
    return _firestore.collection('posts')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
