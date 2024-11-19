import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileRejectedScreen extends StatelessWidget {
  final String userId;

  const ProfileRejectedScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Profile Rejected',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please contact support for more information',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('Back to Welcome Screen'),
            ),
          ],
        ),
      ),
    );
  }
}