import 'package:equatable/equatable.dart';

abstract class StatusState extends Equatable {
  const StatusState();
  
  @override
  List<Object?> get props => [];
}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}

class StatusLoaded extends StatusState {
  final String status;
  final Map<String, dynamic> organizerData;

  const StatusLoaded({
    required this.status,
    required this.organizerData,
  });

  @override
  List<Object?> get props => [status, organizerData];
}

class StatusError extends StatusState {
  final String message;

  const StatusError(this.message);

  @override
  List<Object?> get props => [message];
}