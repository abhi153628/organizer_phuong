import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/modal/transition_modal.dart';
import 'package:testing/view/firebase_auth_services.dart';
import 'package:testing/view/home_page/homepage.dart';
import 'package:testing/view/profile_screen/profile_view_screen.dart';



class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return WideLayout();
          } else {
            return NarrowLayout();
          }
        },
      ),
    );
  }
}

class WideLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: LeftPanel(),
        ),
        Expanded(
          flex: 1,
          child: RightPanel(),
        ),
      ],
    );
  }
}

class NarrowLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          LeftPanel(),
          RightPanel(),
        ],
      ),
    );
  }
}

class LeftPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 0, 0, 0),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Stack(children: [
          Image.asset(
            'asset/crowd-people-with-raised-arms-having-fun-music-festival-by-night.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 450),
                  child: Text(
                    'Phuong Admin Control   ═════════ ',
                    style: GoogleFonts.abel(
                      color: Colors.white,
                      fontSize: 17,fontWeight: FontWeight.w400
                     
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Unlock \n the Stage for\nAuthentic Talent',
                  style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                      height: 1.2),
                ),
                SizedBox(height: 20),
                Text(
                  'Approve true talent and set the stage for unforgettable performances.',
                  style: GoogleFonts.abel(
                    color: Colors.white,
                    fontSize: 15,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}


class RightPanel extends StatefulWidget {
  @override
  _RightPanelState createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  final _auth= FirebaseAuthServices();
  
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _rememberMe = false;
  TextEditingController emailController =TextEditingController();
    TextEditingController passwordController =TextEditingController();

  void _login() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
         
       //  sending the credentials to your backend
     final user = await _auth.loginUserWithEmailAndPassword(emailController.text,passwordController.text);
          Navigator.of(context).push(GentlePageTransition(page: ProfilePage()));
     if(user != null){
      print('Email: $_email, Password: $_password');


     }
     
      

    
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 250, 250, 250),
      child: Padding(
        padding: EdgeInsets.all(120.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 190),
                child: Text(
                  'Phuong',
                  style: GoogleFonts.greatVibes(
                      fontSize: 35,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: Text("Welcome",
                    style: GoogleFonts.philosopher(
                        color: const Color(0xFF7A491C), fontSize: 40)),
              ),
              SizedBox(height: 10),
              Text(
                'Enter your email and password to access your account',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      Text('Remember me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
