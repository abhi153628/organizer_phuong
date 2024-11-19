// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phuong_for_organizer/presentation/profile_page/widgets/custom_silver_appbar_profile.dart';
import 'package:phuong_for_organizer/presentation/profile_page/widgets/profile_bloc/profile_submission_bloc.dart';
import 'package:phuong_for_organizer/presentation/profile_page/widgets/profile_fields.dart';

class ProfileScreen extends StatefulWidget {
 final  String organizerEmail;
  const ProfileScreen({required this.organizerEmail,Key? key}) : super(key: key);


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ScrollController _scrollController;
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }
   void _onScroll() {
    final scrollOffset = _scrollController.offset;
    const maxScroll = 200.0;

    setState(() {
      _scrollProgress = (scrollOffset / maxScroll).clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldColor = Colors.black;
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            CustomSliverAppBar(
              scrollProgress: _scrollProgress,
              title: 'Profile Review',
              scaffoldColor: scaffoldColor,
              onIconPressed: () {},
            ),
            SliverPadding(
              padding: EdgeInsets.all(isLargeScreen ? 24.0 : 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: isLargeScreen ? 30 : 20),
                  ProfileFields(size: size,organizerId: widget.organizerEmail,),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }


}