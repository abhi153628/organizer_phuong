// showing_status.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/presentation/status_page/cstm_modal_sheet.dart';
import 'package:phuong_for_organizer/presentation/status_page/status_screen/status_screen_bloc/bloc/status_screen_bloc.dart';
import 'package:phuong_for_organizer/presentation/status_page/status_screen/status_screen_bloc/bloc/status_screen_event.dart';
import 'package:phuong_for_organizer/presentation/status_page/status_screen/status_screen_bloc/bloc/status_screen_state.dart';

class ShowingStatus extends StatelessWidget {
  final String organizerId;
  
  const ShowingStatus({super.key, required this.organizerId});

  Widget _buildStatusCard(String status, Map<String, dynamic> data) {
    final statusColors = {
      'pending': Colors.orange,
      'approved': Colors.green,
      'rejected': Colors.red,
    };

    final statusMessages = {
      'pending': 'Your profile is under review',
      'approved': 'Congratulations! Your profile has been approved',
      'rejected': 'Your profile needs attention',
    };

    final statusDescriptions = {
      'pending': 'Our team is carefully reviewing your profile. This usually takes 24-48 hours.',
      'approved': 'You can now start creating and managing events on our platform.',
      'rejected': 'Please contact our support team for more information and guidance.',
    };

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColors[status] ?? Colors.grey,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status == 'pending' ? Icons.hourglass_empty :
            status == 'approved' ? Icons.check_circle :
            Icons.error_outline,
            color: statusColors[status],
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            statusMessages[status] ?? '',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            statusDescriptions[status] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String title, String description, bool isCompleted) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? purple : Colors.grey[800],
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.white : Colors.grey,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusBloc()..add(LoadStatus(organizerId)),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Profile Status",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: BlocBuilder<StatusBloc, StatusState>(
          builder: (context, state) {
            if (state is StatusLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Lottie.asset(
                        'asset/animation/Animation - 1731642056954.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Loading your profile status...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }

            if (state is StatusError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            if (state is StatusLoaded) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusCard(state.status, state.organizerData),
                      const SizedBox(height: 32),
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Application Progress',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _buildTimelineStep(
                              'Profile Submitted',
                              'Your profile information has been received',
                              true,
                            ),
                            _buildTimelineStep(
                              'Under Review',
                              'Our team is reviewing your application',
                              state.status != 'pending',
                            ),
                            _buildTimelineStep(
                              'Final Decision',
                              'Application approval status',
                              state.status == 'approved' || state.status == 'rejected',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                      if (state.status == 'approved')
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SuccessBottomSheet(
                            organizerName: state.organizerData['name'] ?? 'Organizer',
                            organizerId: organizerId,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}