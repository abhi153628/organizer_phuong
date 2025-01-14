// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';
import 'package:phuong_for_organizer/presentation/Edit_org_profile_screen/edit_org_prof_adding_screen.dart';
import 'package:phuong_for_organizer/presentation/organizer_profile_view_page/widgets/tabs/feed_view.dart';
import 'package:phuong_for_organizer/presentation/post_feed_screen/post_screen.dart';

class OrganizerProfileViewScreen extends StatelessWidget {
  const OrganizerProfileViewScreen({Key? key, required String organizerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrganizerProfileAddingFirebaseService _firebaseService =
        OrganizerProfileAddingFirebaseService();

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: black, //
        body: FutureBuilder<OrganizerProfileAddingModal?>(
          future: _firebaseService.getCurrentUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child:Lottie.asset('asset/animation/Loading_animation.json',height: 170, width: 170),
              );
            }

            if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text(
                  'No profile found',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            final profile = snapshot.data!;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(profile),
                _buildProfileInfo(profile, context),
                _buildTabBarAndFeed(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
          const SizedBox(height: 16),
          Text(
            'Error: $error',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

 Widget _buildSliverAppBar(OrganizerProfileAddingModal profile) {
  return SliverAppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    expandedHeight: 300,
    pinned: true,
    backgroundColor: Colors.transparent,
    flexibleSpace: FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.expand,
        children: [
        
          if (profile.imageUrl != null)
            // Cached Background Image with Fade Effect
            Stack(
              children: [
                // Background image with ColorFiltered opacity
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                  child: Transform.scale(
                    scale: 2.4, // Scale up the image to ensure it fills the space
                    child: CachedNetworkImage(
                      imageUrl: profile.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              purple.withOpacity(0.3),
                              black,
                            ],
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              purple.withOpacity(0.3),
                              black,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Fade overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        black.withOpacity(0.7),
                        black,
                      ],
                      stops: const [0.4, 0.8, 1.0],
                    ),
                  ),
                ),
              ],
            )
          else
       
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    purple.withOpacity(0.3),
                    black,
                  ],
                ),
              ),
            ),
          // Profile Image
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Hero(
              tag: 'profile_image',
              child: Container(
                height: 180,
                width: 180,
                margin: const EdgeInsets.symmetric(horizontal: 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: purple.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: profile.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: profile.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: Lottie.asset('asset/animation/Loading_animation.json',height: 170, width: 170),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[850],
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white54,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[850],
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white54,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildProfileInfo(
      OrganizerProfileAddingModal profile, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Name
            Text(
              profile.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),

            // Bio
            const SizedBox(height: 16),
            Text(
              profile.bio ?? 'Loading...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

            // Links
            const SizedBox(height: 16),
            ...(profile.links ?? [])
                .map((link) => _buildLinkItem(link))
                .toList(),

            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(profile, context),

            const SizedBox(height: 24),

            // Custom Tab Bar
            TabBar(
              tabs: const [
                Tab(
                  icon: Icon(Icons.grid_view_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem(String link) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          link,
          style: TextStyle(
            color: purple,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      OrganizerProfileAddingModal profile, BuildContext context) {
    return Row(
      children: [
        Expanded(
                  child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              color: white.withOpacity(0.3), width: 2), 
          foregroundColor: purple, 
                  
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
        ),
        onPressed: () {
          Navigator.push(
            context,
            GentlePageTransition(
              page: EditOrganizerProfileScreen(
                organizerId: profile.id ?? '',
                currentName: profile.name,
                currentBio: profile.bio ?? '',
                currentImageUrl: profile.imageUrl ?? '',
                currentLinks: profile.links ?? [],
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit,
                size: 20, color: purple), // Update icon for clarity
            const SizedBox(width: 8),
            Text(
              "Edit Profile",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
                  ),
                ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildButton(
            'Add Feed',
            Icons.add_photo_alternate_outlined,
            () {
              Navigator.of(context).push(
                GentlePageTransition(
                  page: CreatePostScreen(),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20,color: black,),
          const SizedBox(width: 8),
          Text(
            text,
            style:  TextStyle(color: black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarAndFeed() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 1000,
        child: TabBarView(
          children: [FeedView()],
        ),
      ),
    );
  }
}
