import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nour_market2/widgets/sectionwidget.dart';
import '../controllers/home_controller.dart';

class HomeSectionsList extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  HomeSectionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.sections.isEmpty) {
        return const SizedBox();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: controller.sections
            .map((section) => SectionWidget(section: section))
            .toList(),
      );
    });
  }
}
