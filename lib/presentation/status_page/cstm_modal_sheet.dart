// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/presentation/bottom_navbar.dart';

class SuccessBottomSheet extends StatelessWidget {
  final String organizerId;
  final String organizerName;

  const SuccessBottomSheet({
    super.key,
    required this.organizerId,
    required this.organizerName,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('organizers')
          .doc(organizerId)
          .snapshots(),
      builder: (context, snapshot) {
        String? imageUrl;
        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          imageUrl = data?['imageUrl'] as String?;
        }

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Success Animation
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                green.withOpacity(0.7),
                                green.withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: Lottie.asset(
                            'asset/animation/Animation - 1730807964027.json',
                            height: 120,
                            width: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Profile Image
                        Hero(
                          tag: 'profile-$organizerId',
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  purple,
                                  purple.withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.grey[100],
                              child: ClipOval(
                                child: imageUrl != null && imageUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        width: 96,
                                        height: 96,
                                        placeholder: (context, url) => Center(
                                          child: Lottie.asset('asset/animation/Loading_animation.json',height: 170, width: 170),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.person,
                                                size: 40, color: purple),
                                      )
                                    : Icon(Icons.person,
                                        size: 40, color: purple),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Name and Success Message
                        Text(
                          organizerName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Profile Approved!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Congratulations! Your profile has been approved by our admin team. You can now start creating and managing events.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                GentlePageTransition(
                                  page: MainScreen(organizerId: ''),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              foregroundColor: white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.celebration, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  'Start Creating Events',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}