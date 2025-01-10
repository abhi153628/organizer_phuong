// lib/bloc/event_list_event.dart
import 'package:equatable/equatable.dart';


abstract class EventListEvent extends Equatable {
  const EventListEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventListEvent {}

class DeleteEvent extends EventListEvent {
  final String eventId;
  const DeleteEvent(this.eventId);
  
  @override
  List<Object?> get props => [eventId];
}