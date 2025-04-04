import 'package:flutter/material.dart';

class FavoriteBadge extends StatefulWidget {
  const FavoriteBadge({Key? key}) : super(key: key);

  @override
  _FavoriteBadgeState createState() => _FavoriteBadgeState();
}

class _FavoriteBadgeState extends State<FavoriteBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // إعداد الأنميشن ليستمر ويعاود نفسه
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    // تحديد انيميشن الشفافية من 0.5 إلى 1.0
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    // تكرار الأنميشن بشكل عكسي ليصبح تأثير فلاش
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation.value,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          "عضو مميز",
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
