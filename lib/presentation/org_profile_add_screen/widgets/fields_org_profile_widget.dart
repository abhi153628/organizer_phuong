// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';
import 'package:phuong_for_organizer/presentation/org_profile_add_screen/widgets/add_link_wid.dart';

class FieldsOrgProfileWidget extends StatefulWidget {
  final Size size;

  const FieldsOrgProfileWidget({super.key, required this.size});

  @override
  // ignore: library_private_types_in_public_api
  _FieldsOrgProfileWidgetState createState() => _FieldsOrgProfileWidgetState();
}

class _FieldsOrgProfileWidgetState extends State<FieldsOrgProfileWidget> {
  final OrganizerProfileAddingFirebaseService _firebaseService = OrganizerProfileAddingFirebaseService();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isLoading = false;
  List<String> _links = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
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

  Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all required fields')),
    );
    return;
  }

  if (_selectedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a profile image')),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    _uploadedImageUrl = await _firebaseService.uploadImage(_selectedImage!);

    // ignore: unused_local_variable
    final profile = OrganizerProfileAddingModal(
      name: _nameController.text,
      bio: _bioController.text,
      imageUrl: _uploadedImageUrl,
      links: _links,
    );


    setState(() => _isLoading = false);

 if (mounted) {
      // Navigate back to MainScreen with profile tab selected
      Navigator.
      of(context).
      pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Name()
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
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildImagePicker(),
            const SizedBox(height: 30),
            _buildNameField(),
            const SizedBox(height: 30),
            _buildBioField(),
            const SizedBox(height: 30),
            _buildLinksSection(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
               const SizedBox(height: 10),
          ],
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
            : Icon(Icons.add_a_photo, color: Colors.white, size: 40),
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
          }, initialLinks: [],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: purple,
        minimumSize: const Size(140, 40),
      ),
      onPressed: _isLoading ? null : _submitForm,
      child: _isLoading
          ? Lottie.asset('asset/animation/Loading_animation.json',height: 170, width: 170)
          : const Text(
              'Submit',
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
class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}