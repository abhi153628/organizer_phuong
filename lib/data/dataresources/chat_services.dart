
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/chat_message_modal.dart';
import 'dart:async';

class OrganizerChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final OrganizerProfileAddingFirebaseService _organizerProfileService =
      OrganizerProfileAddingFirebaseService();

  // Create or get existing chat room from organizer's perspective
  Future<String> findChatRoomWithUser(String userId) async {
    try {
      // Fetch current organizer's profile
      final organizerProfile = await _organizerProfileService.getCurrentUserProfile();
      print('Organizer profile: $organizerProfile'); // Add this line

      if (organizerProfile == null) {
        print('Organizer not authenticated'); // Add this line
        throw Exception('Organizer not authenticated');
      }

      // Find existing chat room
      print('Searching for existing chat room...'); // Add this line
      final existingRoomQuery = await _firestore
          .collection('chatRooms')
          .where('userId', isEqualTo: userId)
          .where('organizerId', isEqualTo: organizerProfile.id)
          // .limit(1)
          .get();

      print('Existing room query result: ${existingRoomQuery.docs.length}'); // Add this line

      if (existingRoomQuery.docs.isNotEmpty) {
        return existingRoomQuery.docs.first.id;
      }

      // Create a new chat room if it doesn't exist
      print('Creating new chat room...'); // Add this line
      final newChatRoom = await _firestore.collection('chatRooms').add({
        'userId': userId,
        'organizerId': organizerProfile.id,
        'lastMessage': '',
        'lastMessageTimestamp': Timestamp.now(),
      });

      return newChatRoom.id;
    } catch (e) {
      print('Error finding chat room: $e'); // Add this line
      rethrow;
    }
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String receiverId,
    required String content,
  }) async {
    try {
      final organizerProfile = await _organizerProfileService.getCurrentUserProfile();
      if (organizerProfile == null) throw Exception('Not authenticated');

      final batch = _firestore.batch();

      // Update message collection
      print('Updating message collection...'); // Add this line
      final messageRef = _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc();

      // Update chat room
      print('Updating chat room...'); // Add this line
      final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);

      batch.set(messageRef, ChatMessage(
        id: messageRef.id,
        senderId: organizerProfile.id ?? '',
        senderName: organizerProfile.name,
        receiverId: receiverId,
        content: content,
        timestamp: Timestamp.now(),
      ).toMap());

      batch.update(chatRoomRef, {
        'lastMessage': content,
        'lastMessageTimestamp': Timestamp.now(),
      });

      await batch.commit();
    } catch (e) {
      print('Error sending message: $e'); // Add this line
      rethrow;
    }
  }

  Stream<List<ChatMessage>> getMessages(String chatRoomId) {
    print('Fetching messages for chat room: $chatRoomId'); // Add this line
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList());
  }

  Stream<List<ChatRoom>> getOrganizerChatRooms() async* {
    final organizerProfile = await _organizerProfileService.getCurrentUserProfile();
    if (organizerProfile == null) {
      print('Organizer profile is null, returning empty list'); // Add this line
      yield [];
      return;
    }

    print('Fetching chat rooms for organizer: ${organizerProfile.id}'); // Add this line
    yield* _firestore
        .collection('chatRooms')
        .where('organizerId', isEqualTo: organizerProfile.id)
        .orderBy('lastMessageTimestamp', descending: true) // Sort by latest message
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoom.fromFirestore(doc))
            .toList());
  }

  
  Stream<List<ChatRoom>> getChatLIsts() async* {
    final organizerProfile = await _organizerProfileService.getCurrentUserProfile();
    if (organizerProfile == null) {
      print('Organizer profile is null, returning empty list'); // Add this line
      yield [];
      return;
    }

    print('Fetching chat rooms for organizer: ${organizerProfile.id}'); // Add this line
    yield* _firestore
        .collection('chatRooms')
        .where('organizerId', isEqualTo: organizerProfile.id)
        .orderBy('lastMessageTimestamp', descending: true) // Sort by latest message
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoom.fromFirestore(doc))
            .toList());
  }

  Future<void> markMessagesAsRead(String chatRoomId) async {
    try {
      // Fetch current organizer's profile
      final organizerProfile = await _organizerProfileService.getCurrentUserProfile();
      if (organizerProfile == null) return;

      // Get unread messages
      print('Fetching unread messages for chat room: $chatRoomId'); // Add this line
      final unreadMessages = await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('receiverId', isEqualTo: organizerProfile.id)
          .get();

      print('Unread messages found: ${unreadMessages.docs.length}'); // Add this line

      // Batch update to mark as read
      WriteBatch batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      print('Error marking messages as read: $e'); // Add this line
    }
  }
}