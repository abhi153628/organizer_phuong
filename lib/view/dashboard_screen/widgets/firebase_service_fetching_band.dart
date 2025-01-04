import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:testing/view/dashboard_screen/widgets/band_card_widget.dart';
import 'package:testing/view/dashboard_screen/widgets/stats_card.dart';

class FireBaseFetchingBand extends StatefulWidget {
  const FireBaseFetchingBand({super.key});

  @override    FireBaseFetchingBandState createState() => FireBaseFetchingBandState();
}

class FireBaseFetchingBandState extends State<FireBaseFetchingBand> {
  List<Map<String, dynamic>> pendingBands = [];
  bool isLoading = true;
  int totalBands = 0;
  int pendingApprovals = 0;
  int rejectedBands = 0;

  @override
  void initState() {
    super.initState();
    _fetchBands();
  }

  Future<void> _fetchBands() async {
    setState(() {
      isLoading = true;
    });
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('organizers')
          .get();

      List<Map<String, dynamic>> allBands = querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'organizerId': doc.id,
              })
          .toList();

      int pending = 0;
      int rejected = 0;

      for (var band in allBands) {
        if (band['status'] == 'active') {
          pending++;
        } else if (band['status'] == 'rejected') {
          rejected++;
        }
      }

      setState(() {
        pendingBands = allBands.where((band) => band['status'] == 'active').toList();
        totalBands = allBands.length;
        pendingApprovals = pending;
        rejectedBands = rejected;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching bands: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Define responsive values
    int crossAxisCount;
    double childAspectRatio;
    double horizontalPadding;
    double gridSpacing;
    
    // Set responsive breakpoints
    if (screenWidth > 1200) {
      // Large desktop
      crossAxisCount = 3;
      childAspectRatio = 1;
      horizontalPadding = 24;
      gridSpacing = 24;
    } else if (screenWidth > 800) {
      // Small desktop/tablet landscape
      crossAxisCount = 2;
      childAspectRatio = 0.9;
      horizontalPadding = 20;
      gridSpacing = 20;
    } else {
      // Mobile/tablet portrait
      crossAxisCount = 1;
      childAspectRatio = 0.8;
      horizontalPadding = 16;
      gridSpacing = 16;
    }

    if (isLoading) {
      return Center(
        child: SizedBox(
          // Make loading animation responsive
          width: screenWidth < 600 ? screenWidth * 0.6 : 300,
          height: screenWidth < 600 ? screenWidth * 0.6 : 300,
          child: Lottie.asset(
            'asset/Animation - 1729398055158.json',
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatCards(
            totalBands: totalBands,
            pendingApprovals: pendingApprovals,
            rejectedEvents: rejectedBands,
          ),
          SizedBox(height: screenWidth < 600 ? 20 : 40),
          if (pendingBands.isEmpty)
            Center(
              child: Text(
                'No pending band approvals',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: screenWidth < 600 ? 16 : 18,
                ),
              ),
            ),
          if (pendingBands.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: gridSpacing,
                mainAxisSpacing: gridSpacing,
                childAspectRatio: childAspectRatio,
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
      ),
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

      _fetchBands();
    } catch (e) {
      print('Error updating band status: $e');
    }
  }
}