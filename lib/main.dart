import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';

import 'package:phuong_for_organizer/firebase_options.dart';

import 'package:phuong_for_organizer/presentation/Analytics_page/bloc/analytics_image_fetch_bloc.dart';
import 'package:phuong_for_organizer/presentation/event_listing_page/event_listing_page.dart';
import 'package:phuong_for_organizer/presentation/wrapper.dart';






void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseAppCheck.instance.activate(
    // Use provider based on platform
    androidProvider: AndroidProvider.debug,
   
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => LoginBloc(FirebaseAuthServices(),
        //   ),
          
        // )
        BlocProvider(create: (context)=>AnalyticsImageFetchBloc())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(selectionColor: grey),
          inputDecorationTheme: InputDecorationTheme(
            errorStyle: TextStyle(color: purple, fontSize: 13),
          ),
        ),

        
         
        home: EventListPage()
      ),
    );
  }
}
