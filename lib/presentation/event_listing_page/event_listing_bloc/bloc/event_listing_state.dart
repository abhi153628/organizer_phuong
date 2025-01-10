// lib/bloc/event_list_state.dart
import 'package:equatable/equatable.dart';
import 'package:phuong_for_organizer/data/models/event_hosting_modal.dart';

abstract class EventListState extends Equatable {
  const EventListState();
  
  @override
  List<Object?> get props => [];
}

class EventListInitial extends EventListState {}

class EventListLoading extends EventListState {}

class EventListLoaded extends EventListState {
  final List<EventHostingModal> events;
  
  const EventListLoaded(this.events);
  
  @override
  List<Object?> get props => [events];
}

class EventListError extends EventListState {
  final String message;
  
  const EventListError(this.message);
  
  @override
  List<Object?> get props => [message];
}