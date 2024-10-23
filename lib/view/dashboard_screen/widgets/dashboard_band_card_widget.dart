import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:testing/modal/transition_modal.dart';
import 'package:testing/view/home_page/wiidgets/cstm_alertbox.dart';
import 'package:testing/view/profile_screen/profile_view_screen.dart';

class BandCard extends StatelessWidget {
  final Map<String, dynamic> bandData;
  final Function(String, String) onStatusUpdate;
  final bool showAcceptButton;
  final bool showRejectButton;

  const BandCard({
    Key? key,
    required this.bandData,
    required this.onStatusUpdate,
    this.showAcceptButton = true,
    this.showRejectButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          contentPadding: EdgeInsets.zero,
                          content: ProfilePage(
                            organizerId: bandData['organizerId'],
                            width: MediaQuery.of(context).size.width,
                            onStatusUpdate: onStatusUpdate,
                            key: ValueKey(
                                'profile_page_${bandData['organizerId']}'),
                          ),
                        );
                      },
                    );
                  },
                  child: _buildBandImage(bandData['imageUrl']),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bandData['name'] ?? 'Unknown Band',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_getEventType(bandData['eventType'])} • ${bandData['location'] ?? 'Unknown Location'}',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (showAcceptButton)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomAlertDialog(
                                  title: 'Final Confirmation',
                                  subtitle:
                                      'Are you sure you want to accept this event organizer?',
                                  confirmButtonText: 'Yes, Confirm',
                                  cancelButtonText: 'Review Again',
                                  onConfirm: () {
                                    onStatusUpdate(
                                        bandData['organizerId'], 'approved');
                                    Navigator.of(context).pop();
                                  },
                                  onCancel: () => Navigator.of(context).pop(),
                                );
                              },
                            ),
                            child: Text(
                              'Approve',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                      if (showAcceptButton && showRejectButton)
                        const SizedBox(width: 8),
                      if (showRejectButton)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomAlertDialog(
                                  title: 'Final Confirmation',
                                  subtitle:
                                      'Are you sure you want to reject this event organizer?',
                                  confirmButtonText: 'Yes, Confirm',
                                  cancelButtonText: 'Review Again',
                                  onConfirm: () {
                                    onStatusUpdate(
                                        bandData['organizerId'], 'rejected');
                                    Navigator.of(context).pop();
                                  },
                                  onCancel: () => Navigator.of(context).pop(),
                                );
                              },
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'Reject',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBandImage(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return _buildFallbackImage();
  }

  // For web platform, handle CORS
  // if (kIsWeb) {
  //   return FutureBuilder<Uint8List>(
  //     future: _fetchImageBytes(imageUrl),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(
  //           child: CircularProgressIndicator(
  //             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5E1D)),
  //           ),
  //         );
  //       }

  //       if (snapshot.hasError || !snapshot.hasData) {
  //         print('Error loading image: ${snapshot.error}');
  //         return _buildFallbackImage();
  //       }

  //       return Image.memory(
  //         snapshot.data!,
  //         fit: BoxFit.cover,
  //         errorBuilder: (context, error, stackTrace) {
  //           print('Error displaying image: $error');
  //           return _buildFallbackImage();
  //         },
  //       );
  //     },
  //   );
  // }

  // For mobile platforms, use CachedNetworkImage
  // return CachedNetworkImage(
  //   imageUrl: imageUrl,
  //   fit: BoxFit.cover,
  //   placeholder: (context, url) => Center(
  //     child: CircularProgressIndicator(
  //       valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF5E1D)),
  //     ),
  //   ),
  //   errorWidget: (context, url, error) {
  //     print('Error loading image: $error');
  //     return _buildFallbackImage();
  //   },
  // );
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => Center(child: SizedBox(width :50,height: 50,child:  const CircularProgressIndicator())),
    errorWidget: (context, url, error) {
      print('Error loading image: $error');
      print('Error details: ${error.toString()}');
      return const Icon(Icons.error);
    },
  );
}

Future<Uint8List> _fetchImageBytes(String imageUrl) async {
  try {
    // Add cache-busting and necessary parameters
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final urlWithCache =
        '$imageUrl${imageUrl.contains('?') ? '&' : '?'}cache=$timestamp';

    final response = await http.get(
      Uri.parse(urlWithCache),
      headers: {
        'Accept': '*/*',
        'Access-Control-Allow-Origin': '*',
        // Add any Firebase authentication headers if needed
        // 'Authorization': 'Bearer YOUR_TOKEN',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching image: $e');
    throw Exception('Failed to load image: $e');
  }
}

Widget _buildFallbackImage() {
  return Image.asset(
    'asset/william-recinos-qtYhAQnIwSE-unsplash.jpg',
    fit: BoxFit.cover,
  );
}

String _getEventType(int? eventType) {
  switch (eventType) {
    case 0:
      return 'Music Band';
    case 1:
      return 'DJ';
    default:
      return 'Unknown Event Type';
  }
}
