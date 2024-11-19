import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/utils/cstm_sizedbox.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_elevated_button.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_text.dart';

class ProfileSucessScreen extends StatelessWidget {
  const ProfileSucessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          headingText(),
          CstmSizedBox(),
          profileImage(context),
          CstmSizedBox(
            heightFactor: 0.1,
          ),
          bandName(),
            CstmSizedBox(
            heightFactor: 0.01,
          ),
          welcomeText(),
          CstmSizedBox(
            heightFactor: 0.12,
          ),
          goToHomeButton()
        ],
      ),
    );
  }

  Widget headingText() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: CstmText(
        text: 'thaikudam',
        fontSize: 12,
        color: black,
      ),
    );
  }

  Widget profileImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.asset('asset/welcomepage_asset/action-3195378.jpg')),
    );
  }

  Widget bandName() {
    return CstmText(
      text: 'Thaikudam Bridge',
      fontSize: 16,
    );
  }

    Widget welcomeText() {
    return CstmText(
      text: """
            Thank you for waiting - you're verified! 
    Your Phuong profile is now ready for amazing shows. Simple to use, powerful to reach fans,
    made just for creators like you. Ready? 🎵
        """,
      fontSize: 16,
    );
  }

  Widget goToHomeButton() {
    return CustomElevatedButton(text: "Let's Go", onPressed: () {});
  }
}
