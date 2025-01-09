import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing/services/firebase_auth_services.dart';
import 'package:testing/view/home_page/homepage.dart';

class RigtPanelLogin extends StatefulWidget {
  const RigtPanelLogin({super.key, required this.constraints});

  final BoxConstraints constraints;

  @override
  State<RigtPanelLogin> createState() => _RigtPanelLoginState();
}

class _RigtPanelLoginState extends State<RigtPanelLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); // New controller for name
  final _auth = FirebaseAuthServices();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isLogin = true; // Toggle between login and signup

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    }
    if (_isLogin) return null; // Skip additional validation for login
    
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      User? user;

      if (_isLogin) {
        // Login logic
        user = await _auth.signInWithEmailAndPassword(email, password);
      } else {
        // Signup logic
        user = await _auth.createUserEmailAndPassword(email, password);
        // Here you can add additional user info like name to your database
      }

      if (user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e);
      _showErrorSnackbar(errorMessage);
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'weak-password':
        return 'Please enter a stronger password';
      default:
        return 'An error occurred during authentication';
    }
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = _getResponsivePadding(screenSize);

    return Container(
      child: SingleChildScrollView(
        padding: padding,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(screenSize),
              SizedBox(height: _getResponsiveSpacing(50, screenSize)),
              
              // Name field (only for signup)
              if (!_isLogin) ...[
                _buildNameField(screenSize),
                SizedBox(height: _getResponsiveSpacing(20, screenSize)),
              ],
              
              _buildEmailField(screenSize),
              SizedBox(height: _getResponsiveSpacing(20, screenSize)),
              _buildPasswordField(screenSize),
              SizedBox(height: _getResponsiveSpacing(20, screenSize)),
              _buildSubmitButton(screenSize),
              SizedBox(height: _getResponsiveSpacing(20, screenSize)),
              _buildToggleButton(screenSize),
            ],
          ),
        ),
      ),
    );
  }

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
          _isLogin ? "Login" : "Sign Up",
          style: GoogleFonts.philosopher(
            color: const Color(0xFF7A491C),
            fontSize: _getResponsiveFontSize(40, screenSize),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(Size screenSize) {
    return TextFormField(
      controller: _nameController,
      style: TextStyle(fontSize: _getResponsiveFontSize(16, screenSize)),
      decoration: _getInputDecoration('Full Name', Icons.person, screenSize),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
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

  Widget _buildSubmitButton(Size screenSize) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSubmit,
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
              _isLogin ? 'Login' : 'Sign Up',
              style: GoogleFonts.poppins(
                fontSize: _getResponsiveFontSize(15, screenSize),
                color: Colors.white,
              ),
            ),
    );
  }

  Widget _buildToggleButton(Size screenSize) {
    return TextButton(
      onPressed: () => setState(() => _isLogin = !_isLogin),
      child: Text(
        _isLogin
            ? 'Don\'t have an account? Sign Up'
            : 'Already have an account? Login',
        style: GoogleFonts.poppins(
          fontSize: _getResponsiveFontSize(14, screenSize),
          color: Colors.black87,
        ),
      ),
    );
  }

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