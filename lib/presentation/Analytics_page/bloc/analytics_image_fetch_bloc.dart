import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';

part 'analytics_image_fetch_event.dart';
part 'analytics_image_fetch_state.dart';

class AnalyticsImageFetchBloc
    extends Bloc<AnalyticsImageFetchEvent, AnalyticsImageFetchState> {
  AnalyticsImageFetchBloc() : super(AnalyticsImageFetchInitial()) {
    on<FetchProfileEvent>(fetchImage);
    


  }Future<void> fetchImage(FetchProfileEvent event,Emitter <AnalyticsImageFetchState> emit)async{
    try {
      final modal =await OrganizerProfileAddingFirebaseService().getCurrentUserProfile();
      emit(AnalyticsImageFetchSucess(modal: modal!));

      
    } catch (e) {
      emit(AnalyticsImageFetchError(error: '$e'));
      
    }

  }

}

