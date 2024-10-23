import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testing/firebase_options.dart';
import 'package:testing/view/dashboard_screen/dash_board.dart';
import 'package:testing/view/home_page/homepage.dart';

import 'package:testing/view/login_screen/login_page.dart';






void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        
        
      ),
      home:PhuongAdminDashboard()
    );
  }
}


