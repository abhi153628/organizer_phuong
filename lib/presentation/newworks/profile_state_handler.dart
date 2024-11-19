// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:phuong_for_organizer/presentation/bottom_navbar.dart';
// import 'package:phuong_for_organizer/presentation/profile_page/profile_screen.dart';
// import 'package:phuong_for_organizer/presentation/profile_sucess_page/profile_sucess_screen.dart';

// class ProfileStateHandler extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('organizers')
//           .doc(user!.uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }

//         if (snapshot.hasData && snapshot.data!.exists) {
//           final data = snapshot.data!.data() as Map<String, dynamic>;
//           final status = data['status'] as String;

//           if (status == 'approved') {
//             return MainScreen();
//           } else if (status == 'pending') {
//             return ProfileStepper(organizerId: user.uid,);
//           } else {
//             return ProfileStepper(organizerId: user.uid,); //! Create this screen to handle rejections.
//           }
//         }

//         // If no data exists (e.g., profile not created yet)
//         return ProfileScreen(userId: user.uid,);
//       },
//     );
//   }
// }
