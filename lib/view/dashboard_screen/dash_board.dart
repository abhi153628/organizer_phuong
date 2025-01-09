// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/view/dashboard_screen/widgets/dashboard_content.dart';
import 'package:testing/view/dashboard_screen/widgets/sidebar.dart';
import 'package:testing/view_modal/controllers/dashboard_controller.dart';


class ScalableWrapper extends StatelessWidget {
  final Widget child;
  final double designWidth;

 
  const ScalableWrapper({
    Key? key,
    required this.child,
    this.designWidth = 0.7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double currentWidth = constraints.maxWidth;
        double originalDesignWidth = MediaQuery.of(context).size.width * designWidth;
        double scaleFactor = currentWidth / originalDesignWidth;

        return Transform.scale(
          scale: scaleFactor,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: originalDesignWidth,
            child: child,
          ),
        );
      },
    );
  }
}



class PhuongAdminDashboard extends StatelessWidget {
  PhuongAdminDashboard({Key? key}) : super(key: key);

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Widget dashboardContent = Row(
      children: [
        Obx(() => AdminSidebar(
              selectedIndex: controller.selectedIndex,
              onIndexChanged: controller.updateSelectedIndex,
            )),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth > 500 ? 32.0 : 16.0),
              child: Obx(() => DashboardContent(
                    selectedIndex: controller.selectedIndex,
                    totalBands: controller.totalBands,
                    pendingApprovals: controller.pendingApprovals,
                    rejectedBands: controller.rejectedBands.length,
                    rejectedEvents: controller.rejectedBands.length,
                  )),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: ScalableWrapper(
        designWidth: 1,
        child: dashboardContent,
      ),
    );
  }
}