import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/data/dataresources/event_hosting_firebase_service.dart';
import 'package:phuong_for_organizer/firebase_options.dart';
import 'package:phuong_for_organizer/presentation/Analytics_page/bloc/analytics_image_fetch_bloc.dart';
import 'package:phuong_for_organizer/presentation/event_listing_page/event_listing_bloc/bloc/event_listing_bloc.dart';
import 'package:phuong_for_organizer/presentation/wrapper.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseAppCheck.instance.activate(

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
         BlocProvider<EventListBloc>(
          create: (context) => EventListBloc(
            eventService: FirebaseEventService(),
          ),
        ),
       
        BlocProvider(create: (context)=>AnalyticsImageFetchBloc())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(selectionColor: grey),
          inputDecorationTheme: InputDecorationTheme(
            errorStyle: TextStyle(color: red, fontSize: 13),
            
          ),
          
  ),
  home: Wrapper(),
          
        )

        
         
        ,
      );
  
  }
}
