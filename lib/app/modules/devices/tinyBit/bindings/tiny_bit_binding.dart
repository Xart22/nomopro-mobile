import 'package:get/get.dart';

import '../controllers/tiny_bit_controller.dart';

class TinyBitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TinyBitController>(
      () => TinyBitController(),
    );
  }
}
