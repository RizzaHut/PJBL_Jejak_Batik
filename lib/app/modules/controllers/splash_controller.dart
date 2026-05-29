import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final RxDouble opacity = 0.0.obs;
  final RxDouble scale = 0.7.obs;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    opacity.value = 1.0;
    scale.value = 1.0;

    await Future.delayed(const Duration(milliseconds: 2000));
    _navigateToNextPage();
  }

  void _navigateToNextPage() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.welcome);
    }
  }
}
