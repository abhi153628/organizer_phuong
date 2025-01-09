import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
final _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<User?> createUserEmailAndPassword(String email, String password) async {
    try {
      // Create user
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('This email address is already registered. Please try logging in.');
        case 'invalid-email':
          throw Exception('The email address is invalid.');
        case 'operation-not-allowed':
          throw Exception('Email/password accounts are not enabled. Please contact support.');
        case 'weak-password':
          throw Exception('The password is too weak. Please choose a stronger password.');
        default:
          throw Exception('Failed to create account: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
  try {
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } on FirebaseAuthException {
    rethrow;
  }
}

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if email is verified
      if (!userCredential.user!.emailVerified) {
        await _auth.signOut(); // Sign out if email isn't verified
        throw Exception('Please verify your email before logging in.');
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No account found with this email.');
        case 'wrong-password':
          throw Exception('Incorrect password. Please try again.');
        case 'user-disabled':
          throw Exception('This account has been disabled. Please contact support.');
        case 'invalid-email':
          throw Exception('Invalid email address.');
        case 'too-many-requests':
          throw Exception('Too many failed login attempts. Please try again later.');
        default:
          throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }


  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  // Password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw Exception('Invalid email address.');
        case 'user-not-found':
          throw Exception('No account found with this email.');
        default:
          throw Exception('Error sending password reset email: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }
      await currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw Exception('The password is too weak. Please choose a stronger password.');
        case 'requires-recent-login':
          throw Exception('Please log in again before updating your password.');
        default:
          throw Exception('Error updating password: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Check if user exists
  Future<bool> checkIfUserExists(String email) async {
    try {
      // ignore: deprecated_member_use
      final list = await _auth.fetchSignInMethodsForEmail(email);
      return list.isNotEmpty;
    } catch (e) {
      throw Exception('Error checking if user exists: $e');
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }
      await currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'requires-recent-login':
          throw Exception('Please log in again before deleting your account.');
        default:
          throw Exception('Error deleting account: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Reauthenticate user
  Future<void> reauthenticateUser(String password) async {
    try {
      if (currentUser == null || currentUser?.email == null) {
        throw Exception('No user is currently signed in.');
      }

      final credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: password,
      );

      await currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          throw Exception('Incorrect password.');
        default:
          throw Exception('Error reauthenticating: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}