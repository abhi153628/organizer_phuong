// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:phuong_for_organizer/presentation/signup_page/signup_widgets.dart';


// class SignupPage extends StatelessWidget {
//   // ignore: use_super_parameters
//   const SignupPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final mediaSize = MediaQuery.of(context).size;
//     // ignore: prefer_const_declarations
//     final myColor = Colors.black;

//     return Scaffold(
//       body: Stack(
//         children: [
//           _buildBackgroundImage(myColor),
//           _buildBackgroundOverlay(),
//           _buildLogo(),
//           Positioned(
//             bottom: 0,
//             top: 190,
//             child: SingleChildScrollView(child: _buildBottomCard(mediaSize)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBackgroundImage(Color myColor) {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: Container(
//         height: 250,
//         decoration: BoxDecoration(
//           color: myColor,
//           image: DecorationImage(
//             image: const AssetImage(
//                 "asset/welcomepage_asset/crowd-people-with-raised-arms-having-fun-music-festival-by-night.jpg"),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//                 myColor.withOpacity(0.9), BlendMode.dstATop),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBackgroundOverlay() {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Opacity(
//         opacity: 0.1,
//         child: Container(
//           height: 710,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   Widget _buildLogo() {
//     return Center(
//       child: Align(
//         alignment: Alignment.topCenter,
//         child: Padding(
//           padding: const EdgeInsets.only(top: 140),
//           child: Text(
//             'Phuong',
//             style: GoogleFonts.greatVibes(
//               fontSize: 35,
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomCard(Size mediaSize) {
//     return SizedBox(
//       //todo: add color here
      
//       width: mediaSize.width,
//       child: const Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(32.0),
//           child: SignUpWidget(),
//         ),
//       ),
//     );
//   }
// }