// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'package:testing/view/home_page/homepage.dart';
// import 'package:testing/view/login_screen/login_page.dart';

// class Wrapper extends StatelessWidget {
//   const Wrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text('some thing went wrong'),
//               );
//             } else {
//               if (snapshot.data == null) {
//                 return LoginPage();
//               } else {
//                 return HomePage();
//               }
//             }
//           }),
//     );
//   }
// }
