import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';



void showCustomErrorSnackbar(BuildContext context, String title, String message, Color backgroundColor, ) {
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (BuildContext context) => Positioned(
      top: MediaQuery.of(context).viewInsets.top + 1, // Adjust top margin as needed
      width: MediaQuery.of(context).size.width,
      height: 90,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: backgroundColor,
             
                child: Row(
                  children: [
                    // Container(color: red,height: 100,width: 13,),
                
                    const SizedBox(width: 4),
                    Icon(Icons.info,color: red,),
                     const SizedBox(width: 8),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          message,
                                    style: const TextStyle(color:Color.fromARGB(255, 72, 72, 72),fontSize: 12,),
                        ),
                      ],
                    ),
               
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  Overlay.of(context).insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}



void showCustomSucessSnackbar(BuildContext context, String title, String message, Color backgroundColor) {
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (BuildContext context) => Positioned(
      top: MediaQuery.of(context).viewInsets.top + 1, // Adjusting top margin
      width: MediaQuery.of(context).size.width,
      height: 90,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: backgroundColor,
             
                child: Row(
                  children: [
                     Container(color: green,height: 100,width: 13,),
                   
                
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          message,
                          style: const TextStyle(color:Color.fromARGB(255, 72, 72, 72),fontSize: 12,),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
       
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  Overlay.of(context).insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}

