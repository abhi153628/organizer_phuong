import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_text.dart';
import 'dart:io';

import 'package:phuong_for_organizer/data/dataresources/post_feed_firebase_service_class.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File? _selectedImage;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  final PostFeedFirebaseService _firebaseService = PostFeedFirebaseService();

  // Ensure user is authenticated before creating post
  Future<void> _checkUserAuthentication() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showError('Please log in to create a post');
      return;
    }
  }

  Future<void> _pickAndEditImage() async {
    try {
      setState(() => _isLoading = true);
      
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image == null) {
        setState(() => _isLoading = false);
        return;
      }

      File imageFile = File(image.path);

      // Convert image file to bytes for editor
      final imageBytes = await imageFile.readAsBytes();
      
      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: imageBytes,
          ),
        ),
      );

      if (editedImage != null) {
        // Create a new temporary file for the edited image
        final tempDir = await getTemporaryDirectory();
        final String tempPath = '${tempDir.path}/temp_edited_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        File tempFile = File(tempPath);
        await tempFile.writeAsBytes(editedImage);
        
        // Update state with new image file
        setState(() {
          _selectedImage = tempFile;
          _isLoading = false;
        });

        // Clean up old temporary file if it exists and is different from the new one
        if (imageFile.path.contains('temp_edited_image') && imageFile.path != tempPath) {
          try {
            await imageFile.delete();
          } catch (e) {
            print('Error deleting old temporary file: $e');
          }
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to process image: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _createPost() async {
    // Check authentication first
    await _checkUserAuthentication();

    if (_selectedImage == null) {
      _showError('Please select an image');
      return;
    }

    try {
      setState(() => _isLoading = true);

      // Create post using the Firebase service
      await _firebaseService.createPost(
        imageFile: _selectedImage!,
        description: _descriptionController.text.trim(),
      );

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully!')),
      );

      // Navigate back after successful post
      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to create post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Create Post',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (_selectedImage != null)
            TextButton(
              onPressed: _isLoading ? null : _createPost,
              child: Text(
                'Share',
                style: TextStyle(
                  color: purple,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey[800]!),
                            ),
                            child: _selectedImage != null
                                ? Stack(
                                    children: [
                                      Image.file(
                                        _selectedImage!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        key: ValueKey(_selectedImage!.path),
                                      ),
                                      Positioned(
                                        right: 8,
                                        top: 8,
                                        child: IconButton(
                                          onPressed: _pickAndEditImage,
                                          icon: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.7),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: purple,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 16,
                                        ),
                                      ),
                                      onPressed: _pickAndEditImage,
                                      child: const Text(
                                        'Add Photo',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CstmText(
                            text: 'Write your caption first', 
                            fontSize: 20,
                            color: white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      // Description Input
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: _descriptionController,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Write a caption...',
                            hintStyle: TextStyle(color: purple),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[800]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[800]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: purple),
                            ),
                            filled: true,
                            fillColor: Colors.grey[900],
                          ),
                        ),
                      ),

                      // Preview Section
                      if (_selectedImage != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Preview',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[800]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.file(
                                          _selectedImage!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        _descriptionController.text,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}