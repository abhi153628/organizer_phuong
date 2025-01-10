// lib/blocs/profile/profile_bloc.dart
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:phuong_for_organizer/data/dataresources/profile_screen_firebase.dart';
import 'package:phuong_for_organizer/presentation/profile_page/widgets/profile_bloc/profile_submission_event.dart';
import 'package:phuong_for_organizer/presentation/profile_page/widgets/profile_bloc/profile_submission_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseProfileService _profileService = FirebaseProfileService();
  String? _currentImageUrl;

  ProfileBloc() : super(ProfileInitial()) {
    on<UpdateProfileImage>(_handleImageUpload);
    on<SubmitProfileForm>(_handleFormSubmission);
  }

  Future<void> _handleImageUpload(
    UpdateProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      _currentImageUrl=event.image.path;
      // ignore: unused_local_variable
      final organizerId = 'org_${DateTime.now().millisecondsSinceEpoch}';

    } catch (e) {
      emit(ProfileError('Failed to upload image: $e'));
    }
  }

  Future<void> _handleFormSubmission(
    SubmitProfileForm event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
       String? image;
      // Generate a temporary organizerId - replace this with actual user authentication
      final organizerId = 'org_${DateTime.now().millisecondsSinceEpoch}';
      if (_currentImageUrl != null) {
        image = await FirebaseProfileService()
            .addProfileImage(_currentImageUrl!, organizerId);
      }
      log(image.toString());
      await _profileService.saveProfileData(
        organizerId: organizerId,
        name: event.name,
        description: event.description,
        phoneNumber: event.phoneNumber,
        email: event.email,
        location: event.location,
        eventType: event.eventType,
        imageUrl: image,
      );

      emit(ProfileSuccess('Profile updated successfully',organizerId));
    } catch (e) {
      log(e.toString());
      emit(ProfileError('Failed to submit profile: $e'));
    }
  }
}
