import 'package:get/get.dart';

class DashboardController extends GetxController {
  final _selectedIndex = 0.obs;
  final _acceptedBands = <Map<String, dynamic>>[].obs;
  final _rejectedBands = <Map<String, dynamic>>[].obs;
  final _totalBands = 0.obs;
  final _pendingApprovals = 0.obs;

  int get selectedIndex => _selectedIndex.value;
  List<Map<String, dynamic>> get acceptedBands => _acceptedBands;
  List<Map<String, dynamic>> get rejectedBands => _rejectedBands;
  int get totalBands => _totalBands.value;
  int get pendingApprovals => _pendingApprovals.value;

  void updateSelectedIndex(int index) {
    _selectedIndex.value = index;
    if (index == 5) {
      handleLogout();
    }
  }

  void handleLogout() {
    // Implement logout logic
  }
}