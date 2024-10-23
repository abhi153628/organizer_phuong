// lib/screens/admin/dashboard/accepted_bands_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/view/dashboard_screen/widgets/dashboard_band_card_widget.dart';

class AcceptedBandsPage extends StatefulWidget {
  const AcceptedBandsPage({Key? key}) : super(key: key);

  @override
  _AcceptedBandsPageState createState() => _AcceptedBandsPageState();
}

class _AcceptedBandsPageState extends State<AcceptedBandsPage> {
  List<Map<String, dynamic>> acceptedBands = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAcceptedBands();
  }

  Future<void> _fetchAcceptedBands() async {
    setState(() {
      isLoading = true;
    });
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('organizers')
          .where('status', isEqualTo: 'approved')
          .get();

      setState(() {
        acceptedBands = querySnapshot.docs
            .map((doc) => {
                  ...doc.data() as Map<String, dynamic>,
                  'organizerId': doc.id,
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching accepted bands: $e');
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

      _fetchAcceptedBands();
    } catch (e) {
      print('Error updating band status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (acceptedBands.isEmpty) {
      return Center(
        child: Text(
          'No accepted bands',
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
          'Accepted Bands',
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
          itemCount: acceptedBands.length,
          itemBuilder: (context, index) {
            return BandCard(
              bandData: acceptedBands[index],
              onStatusUpdate: _updateBandStatus,
              showAcceptButton: false,
            );
          },
        ),
      ],
    );
  }
}