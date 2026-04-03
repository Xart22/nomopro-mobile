import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:get/get.dart';
import 'package:nomokit/app/services/blue_serial.dart';
import 'package:nomokit/app/services/usb_serial.dart';
import 'package:usb_serial/usb_serial.dart';

class DevicesController extends GetxController {
  var connectionType = Get.arguments;
  var title = "Select Device".obs;

  // USB
  late UsbSerialService usbService;
  var devicesUsb = <UsbDevice>[].obs;
  // BLE
  late BlueSerialService bluetoothService;
  var isDiscovering = true.obs;
  var devicesBt = <Device>[].obs;
  var messages = <Message>[].obs;
  final TextEditingController textEditingController = TextEditingController();
  var indexSelected = 0.obs;
  var selectedBaudRate = 9600.obs;

  startDiscovery() async {
    isDiscovering.value = true;
    devicesBt.clear();
    await bluetoothService.startDiscovery();

    // Use a timer to periodically update the device list
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isDiscovering.value) {
        timer.cancel();
      } else {
        devicesBt.value = List.from(bluetoothService.discoveredDevices);
      }
    });

    // Stop discovery after 10 seconds
    Future.delayed(Duration(seconds: 10), () {
      if (isDiscovering.value) {
        stopDiscovery();
      }
    });
  }

  stopDiscovery() async {
    await bluetoothService.stopDiscovery();
    devicesBt.value = List.from(bluetoothService.discoveredDevices);
    isDiscovering.value = false;
  }

  restartDiscovery() async {
    devicesBt.clear();
    await stopDiscovery();
    await startDiscovery();
  }

  getDevices() async {
    if (connectionType == "usb") {
      usbService.init();
      devicesUsb.value = await UsbSerial.listDevices();

      if (devicesUsb.isEmpty) {
        Get.back();
        Get.snackbar("USB", "No USB devices found",
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      await bluetoothService.init();

      if (!bluetoothService.bluetoothEnabled) {
        Get.back();
        Get.snackbar("Bluetooth", "Bluetooth is not enabled",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      await startDiscovery();
    }
  }

  showModalBaudRate(String route) {
    Get.defaultDialog(
        title: "Select Baud Rate",
        content: Column(
          children: [
            DropdownButtonFormField(
              initialValue: selectedBaudRate.value,
              decoration: const InputDecoration(
                labelText: "Baud Rate",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 9600,
                  child: Text("9600"),
                ),
                DropdownMenuItem(
                  value: 19200,
                  child: Text("19200"),
                ),
                DropdownMenuItem(
                  value: 38400,
                  child: Text("38400"),
                ),
                DropdownMenuItem(
                  value: 57600,
                  child: Text("57600"),
                ),
                DropdownMenuItem(
                  value: 115200,
                  child: Text("115200"),
                ),
                DropdownMenuItem(
                  value: 230400,
                  child: Text("230400"),
                ),
                DropdownMenuItem(
                  value: 460800,
                  child: Text("460800"),
                ),
              ],
              onChanged: (value) {
                selectedBaudRate.value = value as int;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed(route, arguments: [
                        connectionType,
                        devicesUsb[indexSelected.value],
                        selectedBaudRate.value
                      ]);
                    },
                    child: const Text("Save")),
              ],
            ),
          ],
        ),
        barrierDismissible: false);
  }

  @override
  void onInit() {
    super.onInit();
    if (connectionType != 'usb') {
      bluetoothService = Get.find<BlueSerialService>();
      title.value = "Select Bluetooth Device";
    } else {
      usbService = Get.find<UsbSerialService>();
      title.value = "Select USB Device";
    }
    getDevices();
  }

  @override
  void onClose() {
    stopDiscovery();
    super.onClose();
  }
}

class Message {
  int whom;
  String text;

  Message(this.whom, this.text);
}
