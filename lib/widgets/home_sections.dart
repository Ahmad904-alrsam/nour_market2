// lib/widgets/home_sections.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nour_market2/controllers/home_controller.dart';

import '../models/Company.dart';

class HomeSections extends StatelessWidget {
  final String title;

  const HomeSections({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // الحصول على الـ controller من GetX
    final HomeController homeController = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان والايقونة
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
        const SizedBox(height: 10),
        // قائمة أفقية للشركات من البيانات الوهمية
        Obx(() {
          if (homeController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (homeController.companies.isEmpty) {
            return const Center(child: Text("لا توجد شركات متاحة"));
          }
          return SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: homeController.companies.length,
              itemBuilder: (context, index) {
                final company = homeController.companies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.teal,
                        // استخدام Image.network في حال كان لديك رابط للشعار
                        child: (company.logoUrl != null && company.logoUrl!.isNotEmpty)
                            ? ClipOval(
                          child: Image.network(
                            company.logoUrl!,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        )
                            : const Icon(Icons.business, color: Colors.white),


                      ),
                      const SizedBox(height: 5),
                      Text(company.name),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
