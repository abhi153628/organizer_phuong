import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';

import 'package:phuong_for_organizer/data/dataresources/firebase_auth_services.dart';
import 'package:phuong_for_organizer/presentation/loginpage/login_screen.dart';
import 'package:phuong_for_organizer/presentation/signup_page/auth_screen.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth =FirebaseAuthServices();
    return  Center(
      child: ElevatedButton(onPressed: ()async{  await _auth.signOut();
       Navigator.of(context)
                        .push(GentlePageTransition(page: Helo()));
      }, child: Text('signOut')),
    );
  }
}