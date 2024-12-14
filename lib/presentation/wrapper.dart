import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/presentation/bottom_navbar.dart';
import 'package:phuong_for_organizer/presentation/profile_sucess_page/profile_sucess_screen.dart';
import 'package:phuong_for_organizer/presentation/welcome_page/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  // Fetch organizer profile status
  Future<String?> _getOrganizerStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getString('profileStatus');
    log('Retrieved profile status from SharedPreferences: $status');
    return status; // Get saved status
  }

  // Log and handle chat services within Wrapper
  void _logChatService(User user) async {
    log('User email: ${user.email}');
    log('User UID: ${user.uid}');

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch chat rooms for the organizer
    log('Fetching chat rooms for user...');
    final chatRoomsQuery = await firestore
        .collection('chatRooms')
        .where('organizerId', isEqualTo: user.uid)
        .orderBy('lastMessageTimestamp', descending: true)
        .get();

    log('Total chat rooms found: ${chatRoomsQuery.docs.length}');
    for (var room in chatRoomsQuery.docs) {
      log('Chat Room ID: ${room.id}, Data: ${room.data()}');
    }

    // Log messages in a specific chat room
    if (chatRoomsQuery.docs.isNotEmpty) {
      final firstChatRoomId = chatRoomsQuery.docs.first.id;
      log('Fetching messages for chat room: $firstChatRoomId');

      final messagesQuery = await firestore
          .collection('chatRooms')
          .doc(firstChatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      log('Total messages found: ${messagesQuery.docs.length}');
      for (var message in messagesQuery.docs) {
        log('Message ID: ${message.id}, Data: ${message.data()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset('asset/animation/Animation - 1731642056954.json'),
            );
          }

          if (snapshot.hasError) {
            log('Error in authStateChanges stream: ${snapshot.error}');
            return const Center(child: Text("Error occurred."));
          }

          if (snapshot.hasData) {
            final user = snapshot.data!;
            log('User authenticated: UID=${user.uid}, Email=${user.email}');

            // Log chat services data
            _logChatService(user);

            return FutureBuilder<QueryDocumentSnapshot<Map<String, dynamic>>>(
              future: getStatus(user.email!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data?.data();
                  if (data == null) {
                    log('No profile data found for user: ${user.email}');
                    return const Center(child: Text("No profile data found."));
                  } else {
                    final status = data['status'] ?? 'pending';
                    log('User profile status: $status');

                    if (status == 'approved') {
                      return MainScreen(
                        organizerId: user.uid,
                        initialIndex: 0,
                      );
                    }

                    return ShowingStatus(organizerId: snapshot.data!.id);
                  }
                } else {
                  log('Loading profile data for user: ${user.email}');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 300,
                          width: 400,
                          child: Lottie.asset('asset/animation/Animation - 1731642056954.json'),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }

          log('No authenticated user found, showing welcome page.');
          return const WelcomePage();
        },
      ),
    );
  }
}

// Fetch status for the organizer and log details
Future<QueryDocumentSnapshot<Map<String, dynamic>>> getStatus(String email) async {
  log('Fetching profile status for email: $email');

  final query = FirebaseFirestore.instance
      .collection('organizers')
      .where('email', isEqualTo: email);

  final data = await query.get();
  log('Total documents found: ${data.docs.length}');

  if (data.docs.isNotEmpty) {
    final firstDoc = data.docs.first;
    log('First document data: ${firstDoc.data()}');
    return firstDoc;
  } else {
    log('No document found for email: $email');
    throw Exception('No profile data found for email: $email');
  }
}
