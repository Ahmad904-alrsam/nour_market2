import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/faq_controller.dart';
import '../views/FaqDetailPage.dart';

class FaqSection extends StatelessWidget {
  final FaqController faqController;

  const FaqSection({super.key, required this.faqController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        if (faqController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (faqController.faqs.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'الأسئلة الشائعة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                ...faqController.faqs.map((faq) => _buildFaqItem(faq)),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFaqItem(Map<String, dynamic> faq) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        faq['question'] ?? 'سؤال',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        // عند الضغط ينتقل إلى صفحة التفاصيل باستخدام GetX
        Get.to(() => FaqDetailPage(faq: faq));
      },
    );
  }
}
