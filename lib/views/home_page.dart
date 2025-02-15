import 'package:flutter/material.dart';
import 'package:nour_market2/widgets/buildBanner.dart';
import 'package:nour_market2/widgets/custom_app_bar.dart';
import 'package:nour_market2/widgets/home_sections.dart';
import '../widgets/home_categories.dart';
import '../widgets/recommended.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية للمحتويات
    List<String> companies = ['شركة 1', 'شركة 2', 'شركة 3'];
    List<String> recommended = ['موصى به 1', 'موصى به 2', 'موصى به 3'];
    List<String> categories = ['قسم 1', 'قسم 2', 'قسم 3', 'قسم 4'];

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildBanner(), // تأكد من أن اسم الفئة هو BuildBanner (الحروف الكبيرة والصغيرة مهمة)
              SizedBox(height: 10),
              HomeSections(title: 'الشركات'),
              SizedBox(height: 10),
              Recommended(title: 'موصى بها'),
              SizedBox(height: 10),
              HomeCategories(categories: categories),
            ],
          ),
        ),
      ),
    );
  }
}
