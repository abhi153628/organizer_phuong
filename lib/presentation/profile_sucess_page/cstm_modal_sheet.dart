import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/presentation/bottom_navbar.dart';
import 'package:phuong_for_organizer/presentation/home_page/home_screen.dart';
import 'package:phuong_for_organizer/presentation/homepage.dart';
import 'package:phuong_for_organizer/presentation/loginpage/login_screen.dart';

class SuccessBottomSheet extends StatelessWidget {
  final String organizerId;
  final String organizerName;

  const SuccessBottomSheet({
    Key? key,
    required this.organizerId,
    required this.organizerName,
  }) : super(key: key);

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
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: green.withOpacity(0.1),
                    ),
                    child: Lottie.asset(
                      'asset/animation/Animation - 1730807964027.json',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Profile Approved!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Congratulations! Your profile has been approved by our admin team.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    color: purple,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.person, size: 50, color: purple),
                              )
                            : Icon(Icons.person, size: 50, color: purple),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    organizerName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                  Navigator.of(context)
                  .pushAndRemoveUntil(GentlePageTransition(page: MainScreen(pageIndex: 0,profileId: '',)),(route) => false,);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Start Creating Events',
                      style: TextStyle(
                        fontSize: 18,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}