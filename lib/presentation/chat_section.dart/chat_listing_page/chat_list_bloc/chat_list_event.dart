// chat_list_event.dart
import 'package:equatable/equatable.dart';
import 'package:phuong_for_organizer/data/models/chat_message_modal.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatList extends ChatListEvent {}

class SearchChats extends ChatListEvent {
  final String query;

  const SearchChats(this.query);

  @override
  List<Object?> get props => [query];
}

class UpdateChatList extends ChatListEvent {
  final List<ChatRoom> chatRooms;

  const UpdateChatList(this.chatRooms);

  @override
  List<Object?> get props => [chatRooms];
}
