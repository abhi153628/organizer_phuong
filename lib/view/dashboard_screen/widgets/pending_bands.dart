// lib/screens/admin/dashboard/widgets/pending_bands.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/view/dashboard_screen/widgets/dashboard_band_card_widget.dart';

class PendingBands extends StatefulWidget {
  const PendingBands({Key? key}) : super(key: key);

  @override
  _PendingBandsState createState() => _PendingBandsState();
}

class _PendingBandsState extends State<PendingBands> {
  List<Map<String, dynamic>> pendingBands = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingBands();
  }

  Future<void> _fetchPendingBands() async {
    setState(() {
      isLoading = true;
    });
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('organizers')
          .where('status', isEqualTo: 'active')
          .get();

      setState(() {
        pendingBands = querySnapshot.docs
            .map((doc) =>  {
                  ...doc.data() as Map<String, dynamic>,
                  'organizerId': doc.id,
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching pending bands: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pendingBands.isEmpty) {
      return Center(
        child: Text(
          'No pending band approvals',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pending Band Approvals',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1,
          ),
          itemCount: pendingBands.length,
          itemBuilder: (context, index) {
            return BandCard(
              bandData: pendingBands[index],
              onStatusUpdate: _updateBandStatus,
            );
          },
        ),
      ],
    );
  }

  Future<void> _updateBandStatus(String organizerId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('organizers')
          .doc(organizerId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _fetchPendingBands();
    } catch (e) {
      print('Error updating band status: $e');
    }
  }
}