// profile_image_section.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class EventImage extends StatefulWidget {
  final Size size;
  final void Function(XFile image) pickImage;

  const EventImage({
    Key? key,
    required this.size,
    required this.pickImage, String? initialImageUrl,
  }) : super(key: key);

  @override
  _EventImageState createState() => _EventImageState();
}

class _EventImageState extends State<EventImage> {
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
          image = pickedFile;
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