import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phuong_for_organizer/data/dataresources/chat_services.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/chat_message_modal.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';


class OrganizerChatScreen extends StatefulWidget {
  final String userId;
  final String organizerId;
  

  const OrganizerChatScreen({Key? key, required this.userId, required this.organizerId}) : super(key: key);

  @override
  _OrganizerChatScreenState createState() => _OrganizerChatScreenState();
}

class _OrganizerChatScreenState extends State<OrganizerChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final OrganizerChatService _chatService = OrganizerChatService();
  final OrganizerProfileAddingFirebaseService _userProfileService =
      OrganizerProfileAddingFirebaseService();
  String? _chatRoomId;

  @override
  void initState() {
    super.initState();
    _initializeChatRoom();
  }

  Future<void> _initializeChatRoom() async {
    try {
      final chatRoomId = await _chatService.findChatRoomWithUser(widget.userId);

      if (chatRoomId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No existing chat room found')),
        );
        return;
      }

      setState(() {
        _chatRoomId = chatRoomId;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing chat: $e')),
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || _chatRoomId == null) return;

    _chatService.sendMessage(
      chatRoomId: _chatRoomId!,
      receiverId: widget.userId,
      content: _messageController.text.trim(),
    );

    _messageController.clear();
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<OrganizerProfileAddingModal?>(
          future: _userProfileService.getUserProfileById(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }

            if (snapshot.hasError || snapshot.data == null) {
              return Text('Unknown User');
            }

            final userProfile = snapshot.data!;
            return Text(
              userProfile.name,
              style: TextStyle(fontSize: 18),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _chatRoomId == null
                ? Center(child: CircularProgressIndicator())
                : StreamBuilder<List<ChatMessage>>(
                    stream: _chatService.getMessages(_chatRoomId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No messages yet'));
                      }

                      return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final message = snapshot.data![index];
                          final isCurrentUser =
                              message.senderId == FirebaseAuth.instance.currentUser?.uid;

                          return Align(
                            alignment: isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Colors.green[100]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.content,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _formatTimestamp(message.timestamp),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
