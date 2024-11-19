// import 'dart:ui';

// import 'package:flutter/material.dart';

// class ErrorScreen extends StatelessWidget {
//   final String error;
//   final VoidCallback onRetry;

//   const ErrorScreen({
//     Key? key,
//     required this.error,
//     required this.onRetry,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               color: Colors.red,
//               size: 60,
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Text(
//                 'Error: $error',
//                 style: const TextStyle(color: Colors.red),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: onRetry,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }