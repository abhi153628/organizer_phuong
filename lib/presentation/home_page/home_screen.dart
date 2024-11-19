import 'package:flutter/material.dart';

import 'package:phuong_for_organizer/core/widgets/transition.dart';
import 'package:phuong_for_organizer/presentation/event_hosting/event_hosting_page.dart';

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Events')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event_available,
                size: 64,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              const Text(
                'Ready to Create Events!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You can now start creating and managing your events.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(GentlePageTransition(page: EventHostingPage()));
                  },
                  child: const Text('Publish an event'))
            ],
          ),
        ),
      ),
    );
  }
}
