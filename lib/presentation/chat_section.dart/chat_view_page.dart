import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/data/dataresources/chat_services.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/chat_message_modal.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';

class OrganizerChatScreen extends StatefulWidget {
  final String userId;
  final String organizerId;
  final String senderName;

  const OrganizerChatScreen(
      {Key? key,
      required this.userId,
      required this.organizerId,
      required this.senderName})
      : super(key: key);

  @override
  _OrganizerChatScreenState createState() => _OrganizerChatScreenState();
}

class _OrganizerChatScreenState extends State<OrganizerChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final OrganizerChatService _chatService = OrganizerChatService();
  final ScrollController _scrollController = ScrollController();
  final OrganizerProfileAddingFirebaseService _userProfileService =
      OrganizerProfileAddingFirebaseService();
  String? _chatRoomId;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeChatRoom();
    _fetchCurrentUserId();
  }

  Future<void> _fetchCurrentUserId() async {
    try {
      final currentUserProfile =
          await _userProfileService.getCurrentUserProfile();
      setState(() {
        _currentUserId = currentUserProfile?.id; // Safely access the ID
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching current user profile: $e')),
      );
    }
  }

  Future<void> _initializeChatRoom() async {
    try {
      final chatRoomId = await _chatService.findChatRoomWithUser(widget.userId);

      if (chatRoomId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No existing chat room found')),
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
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  void _showDeleteConfirmationDialog(ChatMessage message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Message',
            style: TextStyle(
              fontFamily: 'Rubik',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Do you want to delete this message for everyone?',
            style: TextStyle(
              fontFamily: 'Rubik',
              color: Colors.white70,
            ),
          ),
          backgroundColor: const Color(0xFF2C2C2C),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'Rubik',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteMessageForEveryone(message);
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteMessageForEveryone(ChatMessage message) async {
    try {
      // Only allow deletion if the current user is the sender
      if (message.senderId != _currentUserId) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'You can only delete your own messages',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            duration: Duration(seconds: 2),
          ),
        );

        return;
      }

      // Delete the message from Firestore
      await _chatService.deleteMessage(_chatRoomId!, message.id);

   ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Message deleted successfully',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: purple,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            duration: Duration(seconds: 2),
          ),
        );
    } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Failed to delete message: $e',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            duration: Duration(seconds: 2),
          ),
        );
    }
  }

  Widget _buildMessageBubble({
    required bool isCurrentUser,
    required ChatMessage message,
  }) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteConfirmationDialog(message);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Column(
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Sender Name (for non-current user)
                  if (!isCurrentUser && message.senderName != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 4, left: 8, right: 8),
                      child: Text(
                        message.senderName ?? '',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                  // Message Bubble
                  Container(
                    decoration: BoxDecoration(
                      gradient: isCurrentUser
                          ? const LinearGradient(
                              colors: [Color(0xFF9791FF), Color(0xFF7367F0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF2C2C2C), Color(0xFF3A3A3A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: isCurrentUser
                            ? const Radius.circular(20)
                            : const Radius.circular(0),
                        bottomRight: isCurrentUser
                            ? const Radius.circular(0)
                            : const Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Message Content
                        Text(
                          message.content,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.4,
                            letterSpacing: 0.3,
                          ),
                        ),

                        // Timestamp
                        const SizedBox(height: 6),
                        Text(
                          _formatTimestamp(message.timestamp),
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            color: Colors.white70,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF9791FF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.senderName[0].toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.senderName,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: _chatRoomId == null || _currentUserId == null
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF9791FF),
                        ),
                      )
                    : StreamBuilder<List<ChatMessage>>(
                        stream: _chatService.getMessages(_chatRoomId!),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF9791FF),
                              ),
                            );
                          }

                          final messages = snapshot.data!;
                          return ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];

                              // Use the fetched current user ID
                              final isCurrentUser =
                                  message.senderId == _currentUserId;

                              return _buildMessageBubble(
                                isCurrentUser: isCurrentUser,
                                message: message,
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color(0xFF9791FF).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          fontFamily: 'Rubik',
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9791FF), Color(0xFF7367F0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9791FF).withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void showCustomSnackBar(
      BuildContext context, bool isSuccess, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        duration: Duration(seconds: 3),
        animation: CurvedAnimation(
          parent: AnimationController(
            vsync: Scaffold.of(context),
            duration: const Duration(milliseconds: 500),
          ),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
