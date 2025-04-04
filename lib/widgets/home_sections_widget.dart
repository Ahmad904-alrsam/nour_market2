import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../models/section.dart';

class HomeSectionsWidget extends StatelessWidget {
  final String title;
  final List<Section> sections;

  const HomeSectionsWidget({
    Key? key,
    required this.title,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // يمكنك تخصيص تصميم العرض حسب احتياجاتك
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150, // ارتفاع العرض الافتراضي
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              // مثال بسيط: عرض صورة القسم (من أول بانر إذا وجد) واسمه
              return Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Expanded(
                      child: section.banners.isNotEmpty
                          ? Image.network(
                        section.banners[0].image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image),
                      )
                          : const Icon(Icons.image, size: 50),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      section.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
