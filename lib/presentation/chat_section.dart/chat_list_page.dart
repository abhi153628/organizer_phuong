import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phuong_for_organizer/data/dataresources/chat_services.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/chat_message_modal.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';
import 'package:phuong_for_organizer/presentation/chat_section.dart/chat_view_page.dart';

class OrganizerChatListScreen extends StatefulWidget {
  const OrganizerChatListScreen({super.key});

  @override
  _OrganizerChatListScreenState createState() =>
      _OrganizerChatListScreenState();
}

class _OrganizerChatListScreenState extends State<OrganizerChatListScreen> {
  final OrganizerChatService _chatService = OrganizerChatService();
  final OrganizerProfileAddingFirebaseService _userProfileService =
      OrganizerProfileAddingFirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chats'),
      ),
      body: StreamBuilder<List<ChatRoom>>(
        stream: _chatService.getChatLIsts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Waiting for chat rooms data...');
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error fetching chat rooms: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chatRooms = snapshot.data ?? [];
          print('Chat rooms fetched: ${chatRooms.length}');

          if (chatRooms.isEmpty) {
            print('No active chats found');
            return const Center(child: Text('No active chats'));
          }
         
          else
          {
            Set<String> set={};
            chatRooms.forEach((element) {
                          set.add(element.userId);
                         },);
            var users=[...set];
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context,index){
                return GestureDetector( onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrganizerChatScreen(
                            userId: users[index],
                           organizerId:chatRooms.firstWhere((element) => element.userId==users[index],).organizerId ,
                          ),
                        ),
                      );
                    },
                  child: ListTile(title: Text(users[index],),subtitle: Text(chatRooms.firstWhere((element) => element.userId==users[index],).lastMessage),
                  ),
                );
              });
          }


        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();

    if (now.difference(dateTime).inDays == 0) {
      // Today's messages
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (now.difference(dateTime).inDays < 7) {
      // This week
      return [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ][dateTime.weekday - 1];
    } else {
      // Older messages
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}