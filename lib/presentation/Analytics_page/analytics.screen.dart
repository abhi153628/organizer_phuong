// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_drawer.dart';
import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/data/dataresources/organizer_profile_adding_firebase_service.dart';
import 'package:phuong_for_organizer/data/models/organizer_profile_adding_modal.dart';
import 'package:phuong_for_organizer/presentation/Analytics_page/bloc/analytics_image_fetch_bloc.dart';
import 'package:phuong_for_organizer/presentation/Analytics_page/widgets/analytics_items_widget.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/event_hosting_page.dart';
import 'package:phuong_for_organizer/presentation/organizer_profile_view_page/org_prof_view_screen.dart';

class AnalyticsPage extends StatelessWidget {
  final OrganizerProfileAddingFirebaseService organizer =
      OrganizerProfileAddingFirebaseService();

  AnalyticsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String? organizerId;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Use FutureBuilder to handle async data fetching
    return FutureBuilder<OrganizerProfileAddingModal?>(
        future: organizer.getCurrentUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: black,
              body: Center(
                child: Lottie.asset('asset/animation/Loading_animation.json',
                    height: 170, width: 170),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: black,
              body: Center(
                child: Text(
                  'Error loading profile',
                  style: GoogleFonts.ibmPlexSansArabic(color: white),
                ),
              ),
            );
          }

          final organizerProfile = snapshot.data;
          if (organizerProfile != null) {
            organizerId = organizerProfile.id;
            context.read<AnalyticsImageFetchBloc>().add(
                  FetchProfileEvent(organizerId: organizerProfile.id ?? ''),
                );
          }

          return Scaffold(
            backgroundColor: black,
            drawer: CustomDrawer(),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: Row(
                children: [
                  Text(
                    'Analytics',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                  ),
                  Spacer(),
                  BlocBuilder<AnalyticsImageFetchBloc,
                      AnalyticsImageFetchState>(
                    builder: (context, state) {
                      if (state is AnalyticsImageFetchInitial) {
                        return Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Lottie.asset(
                                'asset/animation/Loading_animation.json',
                                height: 170,
                                width: 170),
                          ),
                        );
                      } else if (state is AnalyticsImageFetchError) {
                        return Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.error_outline, color: Colors.red),
                          ),
                        );
                      } else if (state is AnalyticsImageFetchSucess) {
                        final modal = state.modal;
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OrganizerProfileViewScreen(
                                organizerId: organizerId ?? '',
                              ),
                            ),
                          ),
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[800],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 2),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: purple.withOpacity(0.1),
                                  offset: const Offset(0, 1),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: modal.imageUrl!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: modal.imageUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[800],
                                        child: Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Lottie.asset(
                                                'asset/animation/Loading_animation.json',
                                                height: 170,
                                                width: 170),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'asset/welcomepage_asset/abstral-official-aClNr1q61Cg-unsplash.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      'asset/welcomepage_asset/abstral-official-aClNr1q61Cg-unsplash.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child:
                                Icon(Icons.error_outline, color: Colors.white),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
              backgroundColor: black,
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.05,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Center(
                          child: Lottie.asset(
                              'asset/animation/Animation - 1731554460667.json'),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Center(
                        child: FadeIn(
                          child: Text(
                            'Know and grow your audience',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.013),
                      Center(
                        child: FadeIn(
                          child: Text(
                            'Get detailed insights about your audience.Publish an \n           episode and your analytics will show here',
                            style: GoogleFonts.rubik(
                              fontSize: screenWidth * 0.032,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.06),
                      FadeIn(
                        child: AnalyticsItem(
                          icon: Icons.monetization_on,
                          title: 'Revenue Analytics',
                          description:
                              'Gain insights into your earnings with detailed revenue analysis and growth metrics.',
                          onTap: () {},
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      FadeIn(
                        child: AnalyticsItem(
                          icon: Icons.person_add_alt_1,
                          title: 'Booked Users',
                          description:
                              'Access comprehensive data on users who have confirmed bookings for your services.',
                          onTap: () {},
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      FadeIn(
                        child: AnalyticsItem(
                          icon: Icons.chat_bubble_outline,
                          title: 'Direct Chat Users',
                          description:
                              'Seamlessly connect and communicate with users through direct messaging.',
                          onTap: () {},
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.020),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(GentlePageTransition(
                                page: const EventHostingPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.07,
                              vertical: screenHeight * 0.02,
                            ),
                          ),
                          child: FadeIn(
                            child: Text(
                              'Publish an Event',
                              style: GoogleFonts.ibmPlexSansArabic(
                                color: black,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
