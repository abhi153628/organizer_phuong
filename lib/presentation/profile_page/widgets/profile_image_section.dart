// ignore_for_file: public_member_api_docs, sort_constructors_first
// profile_image_section.dart
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:phuong_for_organizer/core/widgets/cstm_elevated_button.dart';

class ProfileImageSection extends StatefulWidget {
  final Size size;
  final void Function(XFile image) pickImage;

  const ProfileImageSection({
    Key? key,
    required this.size, required this.pickImage
  }) : super(key: key);

  @override
  _ProfileImageSectionState createState() => _ProfileImageSectionState();
}

class _ProfileImageSectionState extends State<ProfileImageSection> {
  XFile? image;
  UploadTask? uploadTask;
  String? downloadUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          InkWell(
            onTap: _pickImage,
            child: _buildImageContainer(),
          ),
          SizedBox(height: 16),
          
          SizedBox(height: 5),
          CustomElevatedButton(
            icon: Icons.upload,
            text: 'Upload Photo',
            onPressed: _pickImage,
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return image == null
        ? Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 73, 73, 73),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.image_search,
              size: 40,
              color: Color.fromARGB(255, 69, 69, 69),
            ),
          )
        : ClipOval(
            child: Image.file(
              File(image!.path),
              width: widget.size.width * 0.35,
              height: widget.size.width * 0.35,
              fit: BoxFit.cover,
            ),
          );
  }


  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
     
      if (pickedFile != null) {
         widget.pickImage(pickedFile);
        setState(() {
          image = XFile(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

 
}