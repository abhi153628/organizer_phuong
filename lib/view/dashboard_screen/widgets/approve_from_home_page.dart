import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:testing/view/dashboard_screen/widgets/band_card_widget.dart';

class ApproveFromHomePage extends StatefulWidget {
  const ApproveFromHomePage({Key? key}) : super(key: key);

  @override
  _ApproveFromHomePageState createState() => _ApproveFromHomePageState();
}

class _ApproveFromHomePageState extends State<ApproveFromHomePage> {
  List<Map<String, dynamic>> acceptedBands = [];
  bool isLoading = true;
  String? errorMessage;
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchAcceptedBands();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final progress = _scrollController.offset /
        (_scrollController.position.maxScrollExtent +
            MediaQuery.of(context).size.height);
    if ((_scrollProgress - progress).abs() > 0.01) {
      setState(() {
        _scrollProgress = progress;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchAcceptedBands() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
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
      setState(() {
        errorMessage = 'Failed to load accepted bands. Please try again later.';
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
      await _fetchAcceptedBands();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update band status. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildGridView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 900) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: acceptedBands.length,
          itemBuilder: (context, index) {
            return BandCard(
              bandData: acceptedBands[index],
              onStatusUpdate: _updateBandStatus,
              showAcceptButton: false,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // Optimized Gradient Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A1A1A),
                    Color.lerp(
                      const Color(0xFF1A1A1A),
                      const Color(0xFFFF5E1D).withOpacity(0.15),
                      _scrollProgress.clamp(0.0, 1.0),
                    )!,
                    const Color(0xFF1A1A1A),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Content
          NotificationListener<ScrollNotification>(
            child: RefreshIndicator(
              color: const Color(0xFFFF5E1D),
              onRefresh: _fetchAcceptedBands,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(24.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Accepted Bands',
                              style: GoogleFonts.ibmPlexSansArabic(
                                color: const Color(0xFFFF5E1D),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh,
                                  color: Colors.white),
                              onPressed: _fetchAcceptedBands,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (isLoading)
                          Center(
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Lottie.asset(
                                'asset/Animation - 1729398055158.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        else if (errorMessage != null)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  errorMessage!,
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF5E1D),
                                  ),
                                  onPressed: _fetchAcceptedBands,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        else if (acceptedBands.isEmpty)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.music_note_outlined,
                                  size: 64,
                                  color:
                                      const Color(0xFFFF5E1D).withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No accepted bands yet',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          _buildGridView(),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
