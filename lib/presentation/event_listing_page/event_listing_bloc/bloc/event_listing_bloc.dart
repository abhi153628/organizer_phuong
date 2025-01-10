// lib/bloc/event_list_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phuong_for_organizer/data/dataresources/event_hosting_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';
import 'package:phuong_for_organizer/presentation/event_listing_page/event_listing_bloc/bloc/event_listing_event.dart';
import 'package:phuong_for_organizer/presentation/event_listing_page/event_listing_bloc/bloc/event_listing_state.dart';


class EventListBloc extends Bloc<EventListEvent, EventListState> {
  final FirebaseEventService _eventService;
  StreamSubscription<QuerySnapshot>? _eventsSubscription;
  
  EventListBloc({required FirebaseEventService eventService}) 
      : _eventService = eventService,
        super(EventListInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventListState> emit) async {
    emit(EventListLoading());
    await _eventsSubscription?.cancel();
    
    try {
      // Using await for to handle the stream properly
      await for (final snapshot in _eventService.getOrganizerEvents()) {
        if (emit.isDone) return;
        
        try {
          final events = snapshot.docs
              .map((doc) => EventHostingModal.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          emit(EventListLoaded(events));
        } catch (e) {
          emit(EventListError('Failed to parse events: $e'));
          break;
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(EventListError('Failed to load events: $e'));
      }
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<EventListState> emit) async {
    try {
      await _eventService.deleteEvent(event.eventId);
      // No need to emit here as the stream will automatically update
    } catch (e) {
      if (!emit.isDone) {
        emit(EventListError('Failed to delete event: $e'));
      }
    }
  }

  @override
  Future<void> close() async {
    await _eventsSubscription?.cancel();
    return super.close();
  }
}