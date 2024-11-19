// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:phuong_for_organizer/data/dataresources/firebase_auth_services.dart';
// import 'package:phuong_for_organizer/presentation/loginpage/bloc/login_bloc_event.dart';
// import 'package:phuong_for_organizer/presentation/loginpage/bloc/login_bloc_state.dart';

// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   final FirebaseAuthServices _authService;

//   LoginBloc(this._authService) : super(LoginInitial()) {
//     on<LoginWithEmailPassword>(_onLoginWithEmailPassword);
//     on<LoginWithGoogle>(_onLoginWithGoogle);
//   }

//   Future<void> _onLoginWithEmailPassword(
//     LoginWithEmailPassword event,
//     Emitter<LoginState> emit,
//   ) async {
//     emit(LoginLoading());
//     try {
//       final user = await _authService.signInWithEmailAndPassword(
      
//        email: '',password: ''
//       );
//       if (user != null) {
//         emit(LoginSuccess(user));
//       } else {
//         emit(const LoginFailure('Login failed'));
//       }
//     } catch (e) {
//       emit(LoginFailure(e.toString()));
//     }
//   }

//   Future<void> _onLoginWithGoogle(
//     LoginWithGoogle event,
//     Emitter<LoginState> emit,
//   ) async {
//     emit(LoginLoading());
//     try {
//       final credential = await _authService.loginWithGoogle();
//       if (credential != null && credential.user != null) {
//         emit(LoginSuccess(credential.user!));
//       } else {
//         emit(const LoginFailure('Google login failed'));
//       }
//     } catch (e) {
//       emit(LoginFailure(e.toString()));
//     }
//   }
// }