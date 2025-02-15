import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/categories_page.dart';

class HomeCategories extends StatelessWidget {
  final List<String> categories;

  const HomeCategories({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم مع أيقونة للتنقل
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الأقسام',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                // الانتقال إلى صفحة الأقسام عند الضغط على الأيقونة
                Get.to(() => CategoriesPage());
              },
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // شبكة من الأقسام لعرض معاينة لبعض التصنيفات الرئيسية
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
