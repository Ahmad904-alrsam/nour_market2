
import 'package:flutter/material.dart';

class FaqDetailPage extends StatelessWidget {
  final Map<String, dynamic> faq;

  const FaqDetailPage({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(faq['question'] ?? 'سؤال'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            faq['answer'] ?? 'إجابة',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
