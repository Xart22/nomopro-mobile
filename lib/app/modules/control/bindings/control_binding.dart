import 'package:get/get.dart';

import '../../../services/blue_serial.dart';
import '../../../services/usb_serial.dart';
import '../controllers/control_controller.dart';

class ControlBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<ControlController>(
      () => ControlController(),
    );
    Get.lazyPut<UsbSerialService>(
      () => UsbSerialService(),
    );
    Get.lazyPut<BlueSerialService>(
      () => BlueSerialService(),
    );
  }
}
