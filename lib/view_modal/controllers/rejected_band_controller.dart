import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RejectedBandsController extends GetxController {
  final RxList<Map<String, dynamic>> rejectedBands = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetchRejectedBands();
    super.onInit();
  }

  Future<void> fetchRejectedBands() async {
    isLoading.value = true;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('organizers')
          .where('status', isEqualTo: 'rejected')
          .get();

      rejectedBands.value = querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'organizerId': doc.id,
              })
          .toList();
    } catch (e) {
      print('Error fetching rejected bands: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBandStatus(String organizerId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('organizers')
          .doc(organizerId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await fetchRejectedBands();
    } catch (e) {
      print('Error updating band status: $e');
    }
  }
}