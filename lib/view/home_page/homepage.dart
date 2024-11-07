import 'package:flutter/material.dart';
import 'package:testing/view/home_page/wiidgets/cauosel.dart';
import 'package:testing/view/home_page/wiidgets/main_widgets_home_page.dart';
import 'package:testing/view/home_page/wiidgets/widgets_home_page.dart';

//! MAIN HOMEPAGE, WIDGETS ARE CLASSIFIED INTO ANOTHER PAGES
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: FractionallySizedBox(
              widthFactor: 1,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        HomePageWidgets.buildBackground(),
                        HomePageWidgets.buttonPicture(),
                        Positioned(top: 650, child: saecondScreen(context)),
                        Positioned(
                            top: 720,
                            left: MediaQuery.of(context).size.width * 0.40,
                            child: scrolledDown()),
                        Positioned(
                            top: 850,
                            left: MediaQuery.of(context).size.width * 0.05,
                            child: secondScreenContainer(context)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HomePageWidgets.buildHeader(context),
                            const SizedBox(height: 48),
                            HomePageWidgets.buildMainContent(context),
                            const Padding(
                              padding: EdgeInsets.only(top: 500, left: 10),
                              child: AnimatedEventCarousel(),
                            ),
                            const SizedBox(height: 1),
                            const SizedBox(height: 50),
                            thirdScreen(context),
                            HomePageWidgets.buildAdminDashboard()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
