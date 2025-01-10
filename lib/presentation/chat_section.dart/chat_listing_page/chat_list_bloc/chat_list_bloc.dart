import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phuong_for_organizer/data/dataresources/chat_services.dart';
import 'package:phuong_for_organizer/presentation/chat_section.dart/chat_listing_page/chat_list_bloc/chat_list_event.dart';
import 'package:phuong_for_organizer/presentation/chat_section.dart/chat_listing_page/chat_list_bloc/chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final OrganizerChatService chatService;
  StreamSubscription? _chatSubscription;

  ChatListBloc({
    required this.chatService,
  }) : super(ChatListInitial()) {
    on<LoadChatList>(_onLoadChatList);
    on<SearchChats>(_onSearchChats);
    on<UpdateChatList>(_onUpdateChatList);
  }

  Future<void> _onLoadChatList(
    LoadChatList event,
    Emitter<ChatListState> emit,
  ) async {
    emit(ChatListLoading());
    try {
      await _chatSubscription?.cancel();
      _chatSubscription = chatService.getChatLIsts().listen(
        (chatRooms) {
          add(UpdateChatList(chatRooms));
        },
        onError: (error) {
          emit(ChatListError('Failed to load chats: $error'));
        },
      );
    } catch (e) {
      emit(ChatListError('Failed to load chats: $e'));
    }
  }

  Future<void> _onSearchChats(
    SearchChats event,
    Emitter<ChatListState> emit,
  ) async {
    if (state is ChatListLoaded) {
      final currentState = state as ChatListLoaded;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }

  Future<void> _onUpdateChatList(
    UpdateChatList event,
    Emitter<ChatListState> emit,
  ) async {
    if (state is ChatListLoaded) {
      final currentState = state as ChatListLoaded;
      emit(currentState.copyWith(chatRooms: event.chatRooms));
    } else {
      emit(ChatListLoaded(chatRooms: event.chatRooms));
    }
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}
