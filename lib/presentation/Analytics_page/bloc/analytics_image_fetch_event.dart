part of 'analytics_image_fetch_bloc.dart';

abstract class AnalyticsImageFetchEvent extends Equatable {
  const AnalyticsImageFetchEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileEvent extends AnalyticsImageFetchEvent {final String organizerId;
 const FetchProfileEvent({required this.organizerId});
  @override
  List<Object> get props => [organizerId];
}
