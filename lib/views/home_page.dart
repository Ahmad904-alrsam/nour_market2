import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nour_market2/widgets/homeSeactionList.dart';
import '../controllers/home_controller.dart';
import '../widgets/buildBanner.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/home_categories.dart';
import '../widgets/home_sections.dart';
import '../widgets/recommended.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () async => await controller.fetchHomeData(),
          child: _buildContent(),
        );
      }),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeSections(title: 'العلامة التجارية'),
            const SizedBox(height: 10),
            BuildBanner(),
            const SizedBox(height: 20),
            RecommendedSection(title: 'منتجات موصى بها'),
            const SizedBox(height: 20),
            HomeCategories(),
            const SizedBox(height: 20),
            HomeSectionsList(),
          ],
        ),
      ),
    );
  }
}