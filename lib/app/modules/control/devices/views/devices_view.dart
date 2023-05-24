import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nomokit/app/modules/control/devices/views/arrow_keys_view.dart';

import '../controllers/devices_controller.dart';
import 'chat_view.dart';

class DevicesView extends GetView<DevicesController> {
  const DevicesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
        centerTitle: true,
        actions: [
          Obx(() => controller.isDiscovering.value == true
              ? FittedBox(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: () {
                    controller.restartDiscovery();
                  },
                ))
        ],
      ),
      body: controller.connectionType == 'usb'
          ? Obx(() => ListView.builder(
                itemCount: controller.devicesUsb.length,
                itemBuilder: (context, index) {
                  return controller.devicesUsb[index];
                },
              ))
          : Obx(() => ListView.builder(
                itemCount: controller.devicesBt.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.devicesBt[index].device.name ?? ''),
                    subtitle: Text(controller.devicesBt[index].device.address),
                    trailing: IconButton(
                      icon: const Icon(Icons.bluetooth),
                      onPressed: () {
                        controller.connect(
                            controller.devicesBt[index].device.address);
                        Get.to(ArrowKeysView());
                      },
                    ),
                  );
                },
              )),
    );
  }
}
