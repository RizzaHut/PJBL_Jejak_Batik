import 'package:get/get.dart';
import '../controllers/galeri_controller.dart';

class GaleriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GaleriController>(() => GaleriController());
  }
}
