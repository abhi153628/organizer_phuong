// status_event.dart
import 'package:equatable/equatable.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object?> get props => [];
}

class LoadStatus extends StatusEvent {
  final String organizerId;

  const LoadStatus(this.organizerId);

  @override
  List<Object?> get props => [organizerId];
}

class UpdateStatus extends StatusEvent {
  final String status;
  final Map<String, dynamic> data;

  const UpdateStatus(this.status, this.data);

  @override
  List<Object?> get props => [status, data];
}
