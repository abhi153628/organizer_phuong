// organizer_profile_view_screen.dart
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_text.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/presentation/Edit_org_profile_screen/edit_org_prof_adding_screen.dart';
import 'package:phuong_for_organizer/presentation/organizer_profile_view_page/widgets/tabs/feed_view.dart';
import 'package:phuong_for_organizer/presentation/post_feed_screen/post_screen.dart';

class OrganizerProfileViewScreen extends StatefulWidget {
  final String organizerId; // Add this to receive the organizer ID
  const OrganizerProfileViewScreen({super.key, required this.organizerId});

  @override
  State<OrganizerProfileViewScreen> createState() =>
      _OrganizerProfileViewScreenState();
}

class _OrganizerProfileViewScreenState
    extends State<OrganizerProfileViewScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = true;
  String? _name;
  String? _bio;
  String? _description;
  String? _imageUrl;
  List<String> _links = [];
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

  // Keeping your existing tabs setup
  final List<Widget> tabs = [
    Tab(icon: Icon(Icons.image, color: purple)),
  ];
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  final List<Widget> TabBarViews = [FeedView()];

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      setState(() => _isLoading = true);

      final profile = await _firebaseService.getProfile(widget.organizerId);

      if (profile != null) {
        setState(() {
          _name = profile.name;
          _description = profile.bio;
          _imageUrl = profile.imageUrl;
          _links = List<String>.from(profile.links ?? []);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _name = 'Profile Not Found';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _name = 'Error Loading Profile';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          backgroundColor: black,
          body: _isLoading
              ? Center(child: CircularProgressIndicator(color: purple))
              : ListView(
                  children: [
                    SizedBox(height: 30),
                    // Profile Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Followers Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CstmText(
                              text: '1234',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                            SizedBox(height: 5),
                            CstmText(
                              text: 'Followers',
                              fontSize: 13,
                              color: white.withOpacity(0.8),
                            )
                          ],
                        ),
                        // Profile Picture
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: white,
                            ),
                            child: _imageUrl != null
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: _imageUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                            color: purple),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.person,
                                        size: 60,
                                        color: grey,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 60,
                                    color: grey,
                                  ),
                          ),
                        ),
                        // Likes Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CstmText(
                              color: white,
                              text: '1234',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 5),
                            CstmText(
                              text: 'Likes',
                              fontSize: 13,
                              color: white.withOpacity(0.8),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Name
                    Center(
                      child: CstmText(
                        color: white,
                        text: _name ?? 'Loading...',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Bio
                    SizedBox(height: 10),
                    Center(
                      child: CstmText(
                        text: _description ?? 'Loading...',
                        fontSize: 20,
                        color: white,
                      ),
                    ),
                    SizedBox(height: 1),
                    // Links
                    ..._links
                        .map((link) => Center(
                              child: CstmText(
                                text: link,
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ))
                        .toList(),
                    SizedBox(height: 25),
                    // Buttons
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: purple),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      GentlePageTransition(
                                        page: EditOrganizerProfileScreen(
                                          organizerId: widget.organizerId,
                                          currentName: _name ?? '',
                                          currentBio: _description ?? '',
                                          currentImageUrl: _imageUrl ?? '',
                                          currentLinks: _links,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CstmText(
                                    text: 'Edit Profile',
                                    fontSize: 18,
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                  ))),
                          SizedBox(width: 20),
                          Expanded(
                              child: OutlinedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: purple),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        GentlePageTransition(
                                            page: CreatePostScreen()));
                                  },
                                  child: CstmText(
                                    text: 'Add Feed',
                                    fontSize: 18,
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Tab Bar
                    TabBar(tabs: tabs),
                    SizedBox(
                        height: 1000, child: TabBarView(children: TabBarViews))
                  ],
                ),
        ));
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
}
