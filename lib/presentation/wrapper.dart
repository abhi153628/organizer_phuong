import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/presentation/bottom_navbar.dart';
import 'package:phuong_for_organizer/presentation/profile_sucess_page/profile_sucess_screen.dart';
import 'package:phuong_for_organizer/presentation/welcome_page/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  Future<String?> _getOrganizerStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileStatus'); // Get saved status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: black,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child:    Lottie.asset('asset/animation/Animation - 1731642056954.json'),);
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error occurred."));
          }

          if (snapshot.hasData) {
            final email = snapshot.data!.email;
            return FutureBuilder<QueryDocumentSnapshot<Map<String, dynamic>>>(
              future: getStatus(email!),
              builder: (context,snapshot) {
                if(snapshot.hasData)
                {
                  var data=snapshot.data?.data();
                  if(data==null)
                  {
                  return const Center(child: Text("No profile data found."));
                  }
                  else
                  {
                      final status = data?['status'] ?? 'pending';
                    if (status == 'approved') {
                        return MainScreen(organizerId: '',initialIndex: 0,);
                      }
                      return ShowingStatus(organizerId: snapshot.data!.id);

                  }
                
                }
                else {
                  return    Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: SizedBox(height: 300,width: 400,child: Lottie.asset('asset/animation/Animation - 1731642056954.json'))),
                    ],
                  );
                }
                
              }
            );
          }
          return const WelcomePage();
        },
      ),
    );
  }
}


Future<QueryDocumentSnapshot<Map<String, dynamic>>> getStatus(String email) async{
  log(email);
  var query= FirebaseFirestore.instance
                  .collection('organizers').where('email',isEqualTo: email);
                  
var data=await query.get();
log(data.docs.length.toString());
log(data.docs.first.data().toString());
return data.docs.first;
}
