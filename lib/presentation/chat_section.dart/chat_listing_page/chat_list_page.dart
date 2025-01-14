import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_drawer.dart';
import 'package:phuong_for_organizer/data/dataresources/chat_services.dart';
import 'package:phuong_for_organizer/data/models/chat_message_modal.dart';
import 'package:phuong_for_organizer/presentation/chat_section.dart/chat_view_page.dart';

class OrganizerChatListScreen extends StatefulWidget {
  const OrganizerChatListScreen({super.key});

  @override
  _OrganizerChatListScreenState createState() =>
      _OrganizerChatListScreenState();
}

class _OrganizerChatListScreenState extends State<OrganizerChatListScreen> {
  final OrganizerChatService _chatService = OrganizerChatService();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          'Messages ',
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
          // Use LayoutBuilder to get constraints
          child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            // This prevents the content from being pushed up
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            color: Colors.white,
                          ),
                          // Add this to prevent scroll
                          scrollPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search conversations',
                            hintStyle: TextStyle(
                              fontFamily: 'Rubik',
                              color: Colors.grey[400],
                            ),
                            prefixIcon: const Icon(Icons.search,
                                color: Color(0xFF9791FF)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ),

                    // Chat List
                    Expanded(
                      child: StreamBuilder<List<ChatRoom>>(
                        stream: _chatService.getChatLIsts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Lottie.asset(
                                  'asset/animation/Loading_animation.json',
                                  height: 170,
                                  width: 170),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                'Unable to load chats',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }

                          final chatRooms = snapshot.data ?? [];
                          if (chatRooms.isEmpty) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 48,
                                    color: Color(0xFF9791FF),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No conversations yet',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: chatRooms.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder<List<ChatMessage>>(
                                stream: _chatService
                                    .getMessages(chatRooms[index].id),
                                builder: (context, messagesSnapshot) {
                                  String senderName = 'Unknown User';

                                  if (messagesSnapshot.hasData &&
                                      messagesSnapshot.data!.isNotEmpty) {
                                    // Filter to get the first message from the user (not organizer)
                                    final userMessages = messagesSnapshot.data!
                                        .where((message) =>
                                            message.senderId !=
                                            chatRooms[index].organizerId)
                                        .toList();

                                    if (userMessages.isNotEmpty) {
                                      senderName =
                                          userMessages.first.senderName;
                                    }
                                  }

                                  return _buildChatTile(
                                    context,
                                    chatRooms[index],
                                    senderName,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ));
      })),
      drawer: CustomDrawer(),
    );
  }

  Widget _buildChatTile(
    BuildContext context,
    ChatRoom chatRoom,
    String senderName,
  ) {
    final initial = (senderName.isNotEmpty) ? senderName[0].toUpperCase() : '?';
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrganizerChatScreen(
                userId: chatRoom.userId,
                organizerId: chatRoom.organizerId,
                senderName: senderName,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF9791FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      senderName.isEmpty ? 'Unknown User' : senderName,
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chatRoom.lastMessage.isEmpty
                          ? 'No messages yet'
                          : chatRoom.lastMessage,
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                _formatTimestampToIndianTime(chatRoom.lastMessageTimestamp),
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestampToIndianTime(Timestamp timestamp) {
    final dateTime =
        timestamp.toDate().add(const Duration(hours: 5, minutes: 30));
    return DateFormat('hh:mm  a').format(dateTime); // e.g., 03:30 PM
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
