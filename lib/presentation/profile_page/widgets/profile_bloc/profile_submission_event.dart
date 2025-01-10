
import 'package:equatable/equatable.dart';

import 'package:image_picker/image_picker.dart';

// Events
abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateProfileImage extends ProfileEvent {
  final XFile image;
  UpdateProfileImage(this.image);

  @override
  List<Object?> get props => [image];
}

class SubmitProfileForm extends ProfileEvent {
  final String name;
  final String description;
  final String phoneNumber;
  final String email;
  final String location;
  final int eventType;
  final String? imageUrl;

  SubmitProfileForm({
    required this.name,
    required this.description,
    required this.phoneNumber,
    required this.email,
    required this.location,
    required this.eventType,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, description, phoneNumber, email, location, eventType, imageUrl];
}