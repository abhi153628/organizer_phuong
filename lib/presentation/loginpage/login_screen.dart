// // File: login_page.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:phuong_for_organizer/core/widgets/transition.dart';
// import 'package:phuong_for_organizer/data/dataresources/firebase_auth_services.dart';
// import 'package:phuong_for_organizer/presentation/loginpage/bloc/login_bloc_bloc.dart';
// import 'package:phuong_for_organizer/presentation/loginpage/bloc/login_bloc_event.dart';
// import 'package:phuong_for_organizer/presentation/loginpage/bloc/login_bloc_state.dart';
// import 'package:phuong_for_organizer/presentation/loginpage/login_Widget.dart';
// import 'package:phuong_for_organizer/presentation/profile_page/profile_screen.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   late Color myColor;
//   late Size mediaSize;
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool rememberUser = false;
//   String? emailError;
//   String? passwordError;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   bool _validateInputs() {
//     bool isValid = true;
//     setState(() {
//       emailError = null;
//       passwordError = null;

//       if (emailController.text.isEmpty) {
//         emailError = 'Email is required';
//         isValid = false;
//       } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//           .hasMatch(emailController.text)) {
//         emailError = 'Enter a valid email address';
//         isValid = false;
//       }

//       if (passwordController.text.isEmpty) {
//         passwordError = 'Password is required';
//         isValid = false;
//       } else if (passwordController.text.length < 6) {
//         passwordError = 'Password must be at least 6 characters long';
//         isValid = false;
//       }
//     });
//     return isValid;
//   }

//   @override
//   Widget build(BuildContext context) {
//     myColor = Colors.black;
//     mediaSize = MediaQuery.of(context).size;
//     return BlocProvider(
//       create: (context) => LoginBloc(FirebaseAuthServices()),
//       child: BlocConsumer<LoginBloc,LoginState>(
//         listener: (context, state) {
//        if (state is LoginSuccess) {
//     Navigator.of(context).pushAndRemoveUntil(GentlePageTransition(page: ProfileScreen(),),(route) => false,);
//     emailController.text='';
//     passwordController.text='';
//        }
       
//     else if (state is LoginFailure) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${state.error}')));
      
//     }
         
       
//         },
//         builder: (context, state) {
//           return Scaffold(
//             body: Stack(
//               children: [
//                 BackgroundImage(),
//                 BlackOverlay(),
//                 BrandName(),
//                 LoginForm(
//                   mediaSize: mediaSize,
//                   emailController: emailController,
//                   passwordController: passwordController,
//                   rememberUser: rememberUser,
//                   onRememberChanged: (value) =>
//                       setState(() => rememberUser = value),
//                   onLogin: (email, password) =>
//                       _login(context, email, password),
//                   googleLogin: () => _googleLogin(context),
//                   emailError: emailError,
//                   passwordError: passwordError,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _login(BuildContext context, String email, String password) {
//     if (_validateInputs()) {
//       BlocProvider.of<LoginBloc>(context)
//           .add(LoginWithEmailPassword(email, password));
//     }
//   }

//   void _googleLogin(BuildContext context) {
//     BlocProvider.of<LoginBloc>(context).add(LoginWithGoogle());
//   }
// }
