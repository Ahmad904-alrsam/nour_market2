import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:nour_market2/views/home_view.dart';
import 'package:nour_market2/views/welcome_view.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: AnimatedLogoWithText(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Color(0xFF021634),
      duration: 4000,
      screenFunction: () async {
        await Future.delayed(Duration(milliseconds: 500));
        return HomeView();
      },
    );
  }
}

class AnimatedLogoWithText extends StatefulWidget {
  @override
  _AnimatedLogoWithTextState createState() => _AnimatedLogoWithTextState();
}

class _AnimatedLogoWithTextState extends State<AnimatedLogoWithText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // تحريك اللوغو
  late Animation<double> _logoScaleAnimation;      // تكبير اللوغو
  late Animation<double> _logoVerticalAnimation;     // الحركة الرأسية للوغو (صعود ونزول)
  late Animation<double> _logoHorizontalAnimation;   // الحركة الأفقية (للانتقال إلى اليمين)

  // تحريك النص
  late Animation<double> _textOpacityAnimation;      // تلاشي النص (ظهور تدريجي)
  late Animation<Offset> _textSlideAnimation;          // تحريك النص أفقيًا (من المنتصف إلى اليسار)

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    // 1. تكبير اللوغو: من 0 إلى 1 خلال أول 20% من مدة التحريك
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    // 2. الحركة الرأسية للوغو: صعود من 0 إلى -50 ثم العودة إلى 0 (من 20% إلى 60%)
    _logoVerticalAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -50.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -50.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.2, 0.6)),
    );

    // 3. الحركة الأفقية للوغو: الانتقال إلى اليمين من 60% إلى 80% (قيم قابلة للتعديل)
    _logoHorizontalAnimation = Tween<double>(begin: 0.0, end: 60.0).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.6, 0.8, curve: Curves.easeInOut)),
    );

    // 4. ظهور النص تدريجيًا: من تلاشي 0 إلى 1 من 60% إلى 100%
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.6, 1.0, curve: Curves.easeIn)),
    );

    // 5. تحريك النص من المنتصف إلى اليسار: من Offset(0,0) إلى Offset(-60,0)
    _textSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-60, 0),
    ).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.6, 1.0, curve: Curves.easeInOut)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // اللوغو: يظهر في المنتصف ثم يتحرك نحو اليمين
            Transform.translate(
              offset: Offset(
                _logoHorizontalAnimation.value,
                _logoVerticalAnimation.value,
              ),
              child: Transform.scale(
                scale: _logoScaleAnimation.value,
                child: Image.asset(
                  'assets/images/photo_2025-02-04_16-43-45-removebg-preview.png',
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            // النص: يظهر في المنتصف ثم يتحرك إلى اليسار ليقع على يسار اللوغو
            Transform.translate(
              offset: _textSlideAnimation.value,
              child: Opacity(
                opacity: _textOpacityAnimation.value,
                child: Text(
                  "نور ماركت",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
