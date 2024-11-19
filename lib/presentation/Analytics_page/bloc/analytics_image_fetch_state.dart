part of 'analytics_image_fetch_bloc.dart';

abstract class AnalyticsImageFetchState extends Equatable {
  const AnalyticsImageFetchState();

  @override
  List<Object> get props => [];
}

class AnalyticsImageFetchInitial extends AnalyticsImageFetchState {
  @override
  List<Object> get props => [];
}

class AnalyticsImageFetchSucess extends AnalyticsImageFetchState {
  final OrganizerProfileAddingModal modal;
  const AnalyticsImageFetchSucess({required this.modal});

  @override
  List<Object> get props => [modal];
}

class AnalyticsImageFetchError extends AnalyticsImageFetchState {
  final String error;
  const AnalyticsImageFetchError({required this.error});
  @override
  List<Object> get props => [error];
}
