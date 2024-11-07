// lib/screens/admin/dashboard/rejected_bands_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/view/dashboard_screen/widgets/band_card_widget.dart';

class RejectedBandsPage extends StatefulWidget {
  const RejectedBandsPage({Key? key}) : super(key: key);

  @override
  _RejectedBandsPageState createState() => _RejectedBandsPageState();
}

class _RejectedBandsPageState extends State<RejectedBandsPage> {
  List<Map<String, dynamic>> rejectedBands = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRejectedBands();
  }

  Future<void> _fetchRejectedBands() async {
    setState(() {
      isLoading = true;
    });
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('organizers')
          .where('status', isEqualTo: 'rejected')
          .get();

      setState(() {
        rejectedBands = querySnapshot.docs
            .map((doc) => {
                  ...doc.data() as Map<String, dynamic>,
                  'organizerId': doc.id,
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching rejected bands: $e');
      setState(() {
        isLoading = false;
      });
    }
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

      _fetchRejectedBands();
    } catch (e) {
      print('Error updating band status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (rejectedBands.isEmpty) {
      return Center(
        child: Text(
          'No rejected bands',
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
          'Rejected Bands',
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
          itemCount: rejectedBands.length,
          itemBuilder: (context, index) {
            return BandCard(
              bandData: rejectedBands[index],
              onStatusUpdate: _updateBandStatus,
              showRejectButton: false,
            );
          },
        ),
      ],
    );
  }
}
