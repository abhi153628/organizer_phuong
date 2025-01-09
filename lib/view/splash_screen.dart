// import 'package:flutter/material.dart';


// import 'package:lottie/lottie.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:testing/view_modal/wrapper.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
//   }

//   Future<void> _initializeApp() async {
//     try {
//       // Preload assets here
//       await Future.wait<void>([
     
//         // Preload Lottie animations
//         _precacheLottieFile(context,'assets/animation1.json'),
//         _precacheLottieFile(context,'assets/animation2.json'),
        
    
//         Future.delayed(const Duration(seconds: 2)),
//       ]);


      
//     } catch (e) {
//       // ignore: avoid_print
//       print('Error loading assets: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
        
//         // Navigate to Wrapper
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const Wrapper()),
//         );
//       }
//     }
//   }



//  Future<void> _precacheLottieFile(BuildContext context, String assetPath) async {
//   try {
//     // Preload the Lottie JSON data
//     await DefaultAssetBundle.of(context).loadString(assetPath);

//   // ignore: empty_catches
//   } catch (e) {

//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Your splash screen logo or animation
//             Lottie.asset(
//               'asset/Animation - 1729398055158.json',
//               width: 200,
//               height: 200,
//             ),
//             const SizedBox(height: 20),
//             if (_isLoading)
//               const CircularProgressIndicator()
//             else
//               Text(
//                 'Loading!',
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }