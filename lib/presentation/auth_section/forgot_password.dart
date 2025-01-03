import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/data/dataresources/firebase_auth_services.dart';

import 'package:phuong_for_organizer/presentation/auth_section/auth_screen.dart';


class ForgotPasswordScreen extends StatefulWidget {
   ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController=TextEditingController();
    final _auth = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
       
        actions: [
          TextButton(
            onPressed: () { Navigator.of(context)
                        .push(GentlePageTransition(page: const Helo()));},
            child:  Text('Create an Account')
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.fingerprint, size: 40, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              const Text(
                'Forgot password?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'No worries, we\'ll send you reset instructions.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              //!textform field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),
              //!send email
              ElevatedButton(
                onPressed: () async{await _auth.sendPasswordResetLink(emailController.text); 
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An email for password reset has been sent to your email ")));
                Navigator.of(context).pop();},
                child: const Text('Reset password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () {Navigator.of(context)
                          .push(GentlePageTransition(page: Helo()));},
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Back to log in'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}