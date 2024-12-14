// organizer_profile_view_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_text.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';

import 'package:phuong_for_organizer/data/dataresources/firebase_auth_services.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';
import 'package:phuong_for_organizer/presentation/Edit_org_profile_screen/edit_org_prof_adding_screen.dart';
import 'package:phuong_for_organizer/presentation/organizer_profile_view_page/widgets/tabs/feed_view.dart';
import 'package:phuong_for_organizer/presentation/post_feed_screen/post_screen.dart';

import 'package:phuong_for_organizer/presentation/welcome_page/welcome_page.dart';

class OrganizerProfileViewScreen extends StatelessWidget {
  const OrganizerProfileViewScreen({Key? key, required String organizerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrganizerProfileAddingFirebaseService _firebaseService = OrganizerProfileAddingFirebaseService();

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: black,
        body: FutureBuilder<OrganizerProfileAddingModal?>(
          future: _firebaseService.getCurrentUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: purple));
            }
            
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No profile found'));
            }

            final profile = snapshot.data!;
            
            return ListView(
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
                        child: profile.imageUrl != null
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: profile.imageUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(color: purple),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
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
                    text: profile.name ?? 'Loading...',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Bio
                SizedBox(height: 10),
                Center(
                  child: CstmText(
                    text: profile.bio ?? 'Loading...',
                    fontSize: 20,
                    color: white,
                  ),
                ),
                SizedBox(height: 1),
                // Links
                ...(profile.links ?? [])
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
                            backgroundColor: purple,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              GentlePageTransition(
                                page: EditOrganizerProfileScreen(
                                  organizerId: profile.id ?? '',
                                  currentName: profile.name ?? '',
                                  currentBio: profile.bio ?? '',
                                  currentImageUrl: profile.imageUrl ?? '',
                                  currentLinks: profile.links ?? [],
                                ),
                              ),
                            );
                          },
                          child: CstmText(
                            text: 'Edit Profile',
                            fontSize: 18,
                            color: white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: OutlinedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              GentlePageTransition(
                                page: CreatePostScreen(),
                              ),
                            );
                          },
                          child: CstmText(
                            text: 'Add Feed',
                            fontSize: 18,
                            color: white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Tab Bar
                TabBar(
                  tabs: [Tab(icon: Icon(Icons.image, color: purple))],
                ),
                SizedBox(
                  height: 1000,
                  child: TabBarView(
                    children: [FeedView()],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
