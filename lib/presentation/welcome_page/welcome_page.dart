// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


import 'package:phuong_for_organizer/presentation/welcome_page/wigets_welcome_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.009,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                const organizersText(),
                const Spacer(),
                const MainContent(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.16),
                Center(child: const GetStartedButton()),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                const TermsAndPrivacyText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

