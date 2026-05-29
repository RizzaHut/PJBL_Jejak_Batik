import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Obx(
          () => AnimatedOpacity(
            opacity: controller.opacity.value,
            duration: const Duration(milliseconds: 800),
            child: AnimatedScale(
              scale: controller.scale.value,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              child: Image.asset(
                'lib/assets/home/logo.png',
                width: 151,
                height: 151,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
