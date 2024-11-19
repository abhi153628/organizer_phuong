import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/presentation/profile_sucess_page/cstm_modal_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowingStatus extends StatelessWidget {
  final String organizerId;

  const ShowingStatus({super.key, required this.organizerId});

  Future<void> _saveOrganizerStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileStatus', status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Status")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('organizers')
            .doc(organizerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset('asset/animation/Animation - 1731642056954.json'),);
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text("No profile data found."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final status = data['status'] ?? 'pending';

          // Sync with SharedPreferences
          if (status == 'approved') {
            _saveOrganizerStatus('approved');
          }

          return Stack(
            children: [
              Column(
                children: [
                  ListTile(
                    title: const Text("Status"),
                    subtitle: Text(status.toUpperCase()),
                  ),
                  if (status == 'rejected')
                    const Text("Your profile is rejected. Contact support."),
                ],
              ),
              if (status == 'approved')
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child:SuccessBottomSheet(
                    organizerName: data['name'] ?? 'Organizer',
                    organizerId: organizerId,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  }
