import 'dart:async';

import 'package:bloc/bloc.dart';



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phuong_for_organizer/presentation/status_page/status_screen/status_screen_bloc/bloc/status_screen_event.dart';
import 'package:phuong_for_organizer/presentation/status_page/status_screen/status_screen_bloc/bloc/status_screen_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final FirebaseFirestore _firestore;
  StreamSubscription<DocumentSnapshot>? _statusSubscription;

  StatusBloc({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(StatusInitial()) {
    on<LoadStatus>(_onLoadStatus);
    on<UpdateStatus>(_onUpdateStatus);
  }

  Future<void> _onLoadStatus(LoadStatus event, Emitter<StatusState> emit) async {
    emit(StatusLoading());
    
    try {
      _statusSubscription?.cancel();
      _statusSubscription = _firestore
          .collection('organizers')
          .doc(event.organizerId)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final status = data['status'] ?? 'pending';
          add(UpdateStatus(status, data));
        }
      });
    } catch (e) {
      emit(StatusError('Failed to load status: $e'));
    }
  }

  Future<void> _onUpdateStatus(UpdateStatus event, Emitter<StatusState> emit) async {
    try {
      if (event.status == 'approved') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileStatus', event.status);
      }
      emit(StatusLoaded(status: event.status, organizerData: event.data));
    } catch (e) {
      emit(StatusError('Failed to update status: $e'));
    }
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    return super.close();
  }
}