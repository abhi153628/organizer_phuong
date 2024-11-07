import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/view/firebase_auth_services.dart';
import 'package:testing/view/home_page/homepage.dart';

//! RIGHT SIDE OF THE LOGIN PAGE

class RigtPanelLogin extends StatefulWidget {
  const RigtPanelLogin({super.key, required BoxConstraints constraints});

  @override
  State<RigtPanelLogin> createState() => _RigtPanelLoginState();
}

class _RigtPanelLoginState extends State<RigtPanelLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuthServices();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Include at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Include at least one lowercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Include at least one number';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Include at least one special character';
    }
    return null;
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      
      final user = await _auth.createUserEmailAndPassword(email, password);
      
      if (user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during signup';
      
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          errorMessage = 'Please enter a stronger password';
          break;
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
     final screenSize = MediaQuery.of(context).size;
    final isWide = screenSize.width > 800;
    final padding = _getResponsivePadding(screenSize);
     return Container(

      child: SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
           
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(screenSize),
                SizedBox(height: _getResponsiveSpacing(50, screenSize)),
                _buildEmailField(screenSize),
                SizedBox(height: _getResponsiveSpacing(20, screenSize)),
                _buildPasswordField(screenSize),
                SizedBox(height: _getResponsiveSpacing(20, screenSize)),
                _buildSignUpButton(screenSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // UI Building methods...
  Widget _buildHeader(Size screenSize) {
    return Column(
      children: [
        Text(
          'Phuong',
          style: GoogleFonts.greatVibes(
            fontSize: _getResponsiveFontSize(35, screenSize),
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: _getResponsiveSpacing(20, screenSize)),
        Text(
          "Sign Up",
          style: GoogleFonts.philosopher(
            color: const Color(0xFF7A491C),
            fontSize: _getResponsiveFontSize(40, screenSize),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(Size screenSize) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: _getResponsiveFontSize(16, screenSize)),
      decoration: _getInputDecoration('Email', Icons.email, screenSize),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!_isValidEmail(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(Size screenSize) {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: TextStyle(fontSize: _getResponsiveFontSize(16, screenSize)),
      decoration: _getInputDecoration(
        'Password',
        Icons.lock,
        screenSize,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            size: _getResponsiveFontSize(24, screenSize),
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
      validator: _validatePassword,
    );
  }

  Widget _buildSignUpButton(Size screenSize) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signup,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: EdgeInsets.symmetric(
          vertical: _getResponsiveSpacing(18, screenSize),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _isLoading
          ? SizedBox(
              height: _getResponsiveSpacing(20, screenSize),
              width: _getResponsiveSpacing(20, screenSize),
              child: const CircularProgressIndicator(color: Colors.white),
            )
          : Text(
              'Sign Up',
              style: GoogleFonts.poppins(
                fontSize: _getResponsiveFontSize(15, screenSize),
                color: Colors.white,
              ),
            ),
    );
  }

  // Helper methods for responsive design
  InputDecoration _getInputDecoration(
      String label, IconData icon, Size screenSize,
      {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: _getResponsiveFontSize(24, screenSize)),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.all(_getResponsiveSpacing(16, screenSize)),
    );
  }

  EdgeInsets _getResponsivePadding(Size screenSize) {
    if (screenSize.width > 1200) {
      return const EdgeInsets.all(120.0);
    } else if (screenSize.width > 800) {
      return const EdgeInsets.all(80.0);
    } else if (screenSize.width > 600) {
      return const EdgeInsets.all(60.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }

  double _getResponsiveFontSize(double baseSize, Size screenSize) {
    double scaleFactor = screenSize.width / 1440;
    return baseSize * scaleFactor.clamp(0.7, 1.2);
  }

  double _getResponsiveSpacing(double baseSpacing, Size screenSize) {
    double scaleFactor = screenSize.width / 1440;
    return baseSpacing * scaleFactor.clamp(0.7, 1.2);
  }
}
