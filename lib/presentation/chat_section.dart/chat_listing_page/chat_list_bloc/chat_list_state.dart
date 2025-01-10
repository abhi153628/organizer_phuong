// chat_list_state.dart
import 'package:equatable/equatable.dart';
import 'package:phuong_for_organizer/data/models/chat_message_modal.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object?> get props => [];
}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatRoom> chatRooms;
  final String searchQuery;

  const ChatListLoaded({
    required this.chatRooms,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [chatRooms, searchQuery];

  ChatListLoaded copyWith({
    List<ChatRoom>? chatRooms,
    String? searchQuery,
  }) {
    return ChatListLoaded(
      chatRooms: chatRooms ?? this.chatRooms,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ChatListError extends ChatListState {
  final String message;

  const ChatListError(this.message);

  @override
  List<Object?> get props => [message];
}
