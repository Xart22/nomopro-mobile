import 'package:get/get.dart';
import 'package:nomokit/app/services/blue_serial.dart';

import '../../../services/usb_serial.dart';
import '../controllers/devices_controller.dart';

class DevicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DevicesController>(
      () => DevicesController(),
    );
    Get.lazyPut(() => UsbSerialService());
    Get.lazyPut(() => BlueSerialService());
  }
}
