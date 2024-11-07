import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing/view/home_page/homepage.dart';
import 'package:testing/view/welcome_screen/welcomes_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    try {
      // Check if there's a current user immediately
      final user = _auth.currentUser;
      
      // Small delay to ensure Firebase is fully initialized
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }

      // If there's a user, verify their token to ensure session is still valid
      if (user != null) {
        try {
          await user.getIdToken();
        } catch (e) {
          // If token refresh fails, sign out the user
          await _auth.signOut();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = true;
        });
      }
      debugPrint('Firebase initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while Firebase initializes
    if (!_initialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show error state if initialization failed
    if (_error) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to initialize Firebase',
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _error = false;
                    _initialized = false;
                  });
                  initializeFirebase();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Use StreamBuilder to listen to auth state changes
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      initialData: _auth.currentUser, // Add this line to use current user as initial data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !_initialized) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          debugPrint('User is logged in: ${user.email}');
          return const HomePage();
        }

        debugPrint('No user logged in');
        return const WelcomePage();
      },
    );
  }
}