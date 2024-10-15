import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices {
  //!signup services
  final _auth = FirebaseAuth.instance;
  Future<User?> createUserEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      print('Something went wrong');
    }
    return null;
  }

  //!login service

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      print('Something went wrong');
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      print('something went Wrong');
    }
  }

  //!google login

  Future<UserCredential?> loginWithGoogle()async{
    try {
      //we will get user details from google
   final googleUser = await  GoogleSignIn().signIn();
  final googleAuth =await googleUser?.authentication;
  final cred= GoogleAuthProvider.credential(idToken: googleAuth?.idToken,accessToken:googleAuth?.accessToken );
  return await  _auth.signInWithCredential(cred);
      
    } catch (e) {
      print(e.toString());
      
    }

  }
  //!email verfication
  Future<void>sendPasswordResetLink(String email)async{
    try {
      await _auth.sendPasswordResetEmail(email: email);
      
    } catch (e) {
      print(e.toString());
      
    }
  }
}
