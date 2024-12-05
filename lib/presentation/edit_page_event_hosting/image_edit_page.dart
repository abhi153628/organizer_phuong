// profile_image_section.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_elevated_button.dart';



class EditEventImage extends StatefulWidget {
  final Size size;
  final Function(XFile) pickImage;
  final String? initialImageUrl;
  final XFile? initialXFile;

  const EditEventImage({
    Key? key,
    required this.size,
    required this.pickImage,
    this.initialImageUrl,
    this.initialXFile,
  }) : super(key: key);

  @override
  _EditEventImageState createState() => _EditEventImageState();
}

class _EditEventImageState extends State<EditEventImage> {
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    // Set initial image if provided
    if (widget.initialXFile != null) {
      _pickedImage = widget.initialXFile;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
      widget.pickImage(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: widget.size.width * 0.9,
        height: 200,
        decoration: BoxDecoration(
          color: grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: purple),
        ),
        child: _pickedImage != null
            ? Image.file(
                File(_pickedImage!.path),
                fit: BoxFit.cover,
              )
            : widget.initialImageUrl != null
                ? Image.network(
                    widget.initialImageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image,
                        color: purple,
                        size: 50,
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          color: purple,
                          size: 50,
                        ),
                        Text(
                          'Upload Event Image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}