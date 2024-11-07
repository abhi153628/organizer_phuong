import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.confirmButtonText,
    required this.cancelButtonText,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 1,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 500,
          width: 600,
          padding: EdgeInsets.only(
            top: 100,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(66, 255, 255, 255),
                blurRadius: 20.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              //!title
              Text(title,
                  style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              SizedBox(
                height: 30,
              ),
              //!subtitle
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 17.0,
                    color: const Color.fromARGB(255, 194, 191, 191),
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 100,
              ),
              Row(
                //!buttons

                children: <Widget>[
                  Spacer(),
                  SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: onCancel,
                      child: Text(cancelButtonText,
                          style: GoogleFonts.aBeeZee(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5E1D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: onConfirm,
                      child: Text(
                        confirmButtonText,
                        style: GoogleFonts.aBeeZee(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: const Color(0xFFFF5E1D),
            radius: 50,
            child: Icon(
              Icons.assistant_photo,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// Usage example
void showCustomDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: CustomAlertDialog(
            title: "Alert Title",
            subtitle: "This is the alert message. You can customize this text.",
            confirmButtonText: "Confirm",
            cancelButtonText: "Cancel",
            onConfirm: () {
              // Handle confirm action
              Navigator.of(context).pop();
            },
            onCancel: () {
              // Handle cancel action
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (context, animation1, animation2) {
      return Container(); // This widget is not used but required
    },
  );
}
