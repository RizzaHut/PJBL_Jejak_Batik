import 'package:get/get.dart';
import '../controllers/hasil_scan_controller.dart';

class HasilScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HasilScanController>(() => HasilScanController());
  }
}
