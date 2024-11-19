

// States
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final String message;
  final String organizerId;
  ProfileSuccess(this.message, this.organizerId);

  @override
  List<Object?> get props => [message];
}

class ProfileError extends ProfileState {
  final String error;
  ProfileError(this.error);

  @override
  List<Object?> get props => [error];
}

class ImageUploadSuccess extends ProfileState {
  final String imageUrl;
  ImageUploadSuccess(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}