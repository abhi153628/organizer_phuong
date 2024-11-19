// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:phuong_for_organizer/core/widgets/transition.dart';
// import 'package:phuong_for_organizer/data/dataresources/firebase_auth_services.dart';
// import 'package:phuong_for_organizer/presentation/bottom_navbar.dart';
// import 'package:phuong_for_organizer/presentation/homepage.dart';
// import 'package:phuong_for_organizer/presentation/loginpage/login_screen.dart';



// class SignUpWidget extends StatefulWidget {
//   const SignUpWidget({Key? key}) : super(key: key);

//   @override
//   _SignUpWidgetState createState() => _SignUpWidgetState();
// }

// class _SignUpWidgetState extends State<SignUpWidget> {
//   final _auth = FirebaseAuthServices();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text("Sign up",
//                 style: GoogleFonts.philosopher(
//                     color: Color(0xFF7A491C), fontSize: 30)),
//             const SizedBox(height: 10),
//             _buildGreyText("Email address"),
//             _buildInputField(emailController, isEmail: true),
//             const SizedBox(height: 20),
//             _buildGreyText("Password"),
//             _buildInputField(passwordController, isPassword: true),
//             const SizedBox(height: 20),
//             _buildGreyText("Confirm Password"),
//             _buildInputField(confirmPasswordController, isPassword: true),
//             const SizedBox(height: 30),
//             _buildSignupButton(),
//             const SizedBox(height: 20),
//             _buildOtherLoginOptions(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGreyText(String text) {
//     return Text(
//       text,
//       style: const TextStyle(color: Color.fromARGB(255, 1, 1, 1)),
//     );
//   }

//   Widget _buildInputField(TextEditingController controller,
//       {bool isPassword = false, bool isEmail = false}) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
//       ),
//       obscureText: isPassword,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'This field cannot be empty';
//         }
//         if (isEmail && !_isValidEmail(value)) {
//           return 'Enter a valid email';
//         }
//         if (isPassword && controller == confirmPasswordController) {
//           if (value != passwordController.text) {
//             return 'Passwords do not match';
//           }
//         }
//         return null;
//       },
//     );
//   }

//   bool _isValidEmail(String email) {
//     return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
//         .hasMatch(email);
//   }

//   Widget _buildSignupButton() {
//     return Center(
//       child: SizedBox(width: 180,height: 50,
//         child: ElevatedButton(
//           onPressed: _signUp,
//           style: ElevatedButton.styleFrom(
         
//             elevation: 4,
//             shadowColor: Color.fromARGB(255, 255, 255, 255),
//             maximumSize: Size.fromHeight(60),
//             backgroundColor: Color(0xFF9791FF),
//             overlayColor: Color.fromARGB(255, 255, 255, 255),
        
//           ),
//           child: Text(
//             "Sign Up",
//             style: GoogleFonts.aBeeZee(
//                 color: Color.fromARGB(255, 255, 255, 255), fontSize: 17,fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOtherLoginOptions() {
//     return Center(
//       child: Column(
//         children: [
//           _buildGreyText(
//               "----------------------Or Sign up with----------------------"),
//           const SizedBox(height: 10),
//           _buildGoogleSignupButton(),
//           const SizedBox(height: 10),
//           _buildLoginLink(),
//         ],
//       ),
//     );
//   }

//   Widget _buildGoogleSignupButton() {
//     return SizedBox(width: 180,height: 50,
//       child: OutlinedButton(
//         onPressed: () {
//           Navigator.of(context)
//               .push(GentlePageTransition(page: Homepage()));
//         },
//         style: ElevatedButton.styleFrom(
         
        
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(
//               'asset/welcomepage_asset/pngwing.com.png',
//               height: 20.0,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               "Google",
//               style: GoogleFonts.aBeeZee(
//                   color: Color.fromARGB(255, 255, 255, 255), fontSize: 15,fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginLink() {
//     return Row(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 30),
//           child: Text(
//             "Already have an account?",
//             style: GoogleFonts.aBeeZee(
//                 color: Color.fromARGB(255, 0, 0, 0), fontSize: 15),
//           ),
//         ),
//         TextButton(
//             onPressed: () {
//               // Navigator.of(context)
//               //     .push(GentlePageTransition(page: LoginPage()));
//             },
//             child: Text('Login'))
//       ],
//     );
//   }

//   void _signUp() async {
//     if (_formKey.currentState!.validate()) {
//    await _auth.createUserEmailAndPassword(
//           emailController.text, passwordController.text);
//             Navigator.of(context)
//             .push(GentlePageTransition(page: MainScreen(organizerId: ,)));
//             emailController.text='';
//             passwordController.text='';
//             confirmPasswordController.text='';
          
//  }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }