import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';

import 'package:phuong_for_organizer/presentation/auth_section/auth_screen.dart';


class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
           Color.fromARGB(255, 138, 132, 248),
            Color(0xFF9791FF),
            Color.fromARGB(255, 197, 203, 233),
            Color.fromARGB(255, 197, 203, 233),
          ],
        ),
      ),
      child: child,
    );
  }
}

class organizersText extends StatelessWidget {
  const organizersText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 300),
        child: Row(
          children: [
            SizedBox(
              width: 90,
            ),
            //todo : want add logo of the app
            Text(
              'for Organizers',
              style: GoogleFonts.aBeeZee(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  letterSpacing: .001,
                  height: 1),
            ),
          ],
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '    Get discovered\n  Connect with fans\n    Grow your show.',
        style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.height * 0.033,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: .001,
            height: 1),
      ),
    );
  }
}

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
 onPressed: () {
  Navigator.of(context)
      .pushReplacement(GentlePageTransition(page: Helo()));
},

      child: Text(
        'Get started',
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.02,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: Size(
          MediaQuery.of(context).size.width * 0.4,
          MediaQuery.of(context).size.height * 0.06,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'By continuing, you agree to the Terms of Service and Privacy Policy.',
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.height * 0.011,
        color: Colors.black54,
      ),
    );
  }
}
