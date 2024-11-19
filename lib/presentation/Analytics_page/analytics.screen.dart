// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/presentation/Analytics_page/bloc/analytics_image_fetch_bloc.dart';
import 'package:phuong_for_organizer/presentation/Analytics_page/widgets/analytics_items_widget.dart';

class AnalyticsPage extends StatelessWidget {

  AnalyticsPage({
    Key? key,

  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    context.read<AnalyticsImageFetchBloc>().add(FetchProfileEvent(organizerId: 't2NqAwtPtUmOdFNb8AwC'));
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(backgroundColor: black,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Analytics',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
            Spacer(),
            BlocBuilder<AnalyticsImageFetchBloc, AnalyticsImageFetchState>(
              builder: (context, state) {
                if (state is AnalyticsImageFetchInitial) {
              return    const CircularProgressIndicator();
                  
                }else if(state is AnalyticsImageFetchError){
                  return Text(state.error);

                }
                else if(state is AnalyticsImageFetchSucess)
                {
                  final modal = state.modal;
                  return CircleAvatar(child: modal.imageUrl!.isNotEmpty?CachedNetworkImage(imageUrl: modal.imageUrl!):Image.asset('asset/welcomepage_asset/abstral-official-aClNr1q61Cg-unsplash.jpg'));


                }
                else{
                  return const Text('something went wrong');
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
                  child: Text(
                    'Know and grow your audience',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.013),
                Center(
                  child: Text(
                    'Get detailed insights about your audience.Publish an \n           episode and your analytics will show here',
                    style: GoogleFonts.rubik(
                      fontSize: screenWidth * 0.032,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
               AnalyticsItem(
  icon: Icons.favorite,
  title: 'Follower Growth',
  description: 'See your follower growth over time and track engagement.',
  onTap: () {},
),
SizedBox(height: screenHeight * 0.04),
AnalyticsItem(
  icon: Icons.location_on,
  title: 'Audience Location',
  description: 'Find out where your fans are located to plan events.',
  onTap: () {},
),
SizedBox(height: screenHeight * 0.04),
AnalyticsItem(
  icon: Icons.bar_chart,
  title: 'Event Performance',
  description: 'View metrics on attendance, sales, and fan interaction.',
  onTap: () {},
),

                SizedBox(height: screenHeight * 0.038),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.07,
                        vertical: screenHeight * 0.02,
                      ),
                    ),
                    child: Text(
                      'Publish an episode',
                      style: GoogleFonts.ibmPlexSansArabic(
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
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
  }
}
