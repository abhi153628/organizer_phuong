import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';
import 'package:phuong_for_organizer/presentation/bottom_navbar.dart';
import 'package:phuong_for_organizer/presentation/org_profile_add_screen/widgets/add_link_wid.dart';


class EditOrganizerProfileScreen extends StatefulWidget {
  final String organizerId;
  final String currentName;
  final String currentBio;
  final String currentImageUrl;
  final List<String> currentLinks;

  const EditOrganizerProfileScreen({
    super.key,
    required this.organizerId,
    required this.currentName,
    required this.currentBio,
    required this.currentImageUrl,
    required this.currentLinks,
  });

  @override
  State<EditOrganizerProfileScreen> createState() => _EditOrganizerProfileScreenState();
}

class _EditOrganizerProfileScreenState extends State<EditOrganizerProfileScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isLoading = false;
  List<String> _links = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _bioController = TextEditingController(text: widget.currentBio);
    _links = List.from(widget.currentLinks);
    _uploadedImageUrl = widget.currentImageUrl;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Only upload new image if one was selected
      if (_selectedImage != null) {
        _uploadedImageUrl = await _firebaseService.uploadImage(_selectedImage!);
      }

      // Create updated profile
      final updatedProfile = OrganizerProfileAddingModal(
        id: widget.organizerId,
        name: _nameController.text,
        bio: _bioController.text,
        imageUrl: _uploadedImageUrl,
        links: _links,
      );

      // Update profile in Firestore
      await _firebaseService.updateProfile(updatedProfile);

      setState(() => _isLoading = false);

     if (mounted) {
      // Navigate back to MainScreen with profile tab selected
      Navigator.
      of(context).
      pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MainScreen(organizerId: '', initialIndex: 1,)
        ),
        (route) => false, // This removes all previous routes
      );

      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        title: Text('Edit Profile', style: TextStyle(color: white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildImagePicker(),
              const SizedBox(height: 30),
              _buildNameField(),
              const SizedBox(height: 30),
              _buildBioField(),
              const SizedBox(height: 30),
              _buildLinksSection(),
              const SizedBox(height: 30),
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(60),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CachedNetworkImage(
                  imageUrl: widget.currentImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(color: purple),
                  errorWidget: (context, url, error) =>
                      // ignore: prefer_const_constructors
                      Icon(Icons.add_a_photo, color: Colors.white, size: 40),
                ),
              ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: "Your Name",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bio', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _bioController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Tell what your show is about",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a Bio';
            }
            return null;
          },
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildLinksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Add your Links', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        AddLinkWidget(
          onRulesChanged: (List<String> updatedLinks) {
            setState(() {
              _links = updatedLinks;
            });
          },
          initialLinks: widget.currentLinks,
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: purple,
        minimumSize: const Size(140, 40),
      ),
      onPressed: _isLoading ? null : _updateProfile,
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'Update Profile',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}