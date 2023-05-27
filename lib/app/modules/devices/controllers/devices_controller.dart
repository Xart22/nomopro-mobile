import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:nomokit/app/services/blue_serial.dart';
import 'package:nomokit/app/services/usb_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usb_serial/usb_serial.dart';

class DevicesController extends GetxController {
  var connectionType = Get.arguments;
  var title = "Select Device".obs;

  // USB
  late UsbSerialService usbService;
  var devicesUsb = <UsbDevice>[].obs;
  // BLE
  late BlueSerialService bluetoothService;
  StreamSubscription<BluetoothDiscoveryResult>? deviceStreamSubscription;
  var isDiscovering = true.obs;
  var devicesBt = <BluetoothDiscoveryResult>[].obs;
  var messages = <Message>[].obs;
  final TextEditingController textEditingController = TextEditingController();
  var indexSelected = 0.obs;
  var selectedBaudRate = 9600.obs;

  startDiscovery() async {
    isDiscovering.value = true;
    devicesBt.clear();
    deviceStreamSubscription = bluetoothService.startDiscovery((result) {
      devicesBt.add(result!);
    });
    deviceStreamSubscription?.onDone(() {
      isDiscovering.value = false;
    });
  }

  stopDiscovery() async {
    deviceStreamSubscription?.cancel();
    isDiscovering.value = false;
  }

  restartDiscovery() async {
    devicesBt.clear();
    stopDiscovery();
    startDiscovery();
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

      if (bluetoothService.bluetoothState == BluetoothState.STATE_OFF ||
          bluetoothService.bluetoothState == BluetoothState.STATE_TURNING_OFF ||
          bluetoothService.bluetoothState == BluetoothState.UNKNOWN) {
        await FlutterBluetoothSerial.instance.requestEnable().then((value) {
          if (value == true) {
            startDiscovery();
          } else {
            Get.back();
            Get.snackbar("Bluetooth", "Bluetooth is not enabled",
                snackPosition: SnackPosition.BOTTOM);
          }
        });
      }
    }
  }

  showModalBaudRate(String route) {
    Get.defaultDialog(
        title: "Select Baud Rate",
        content: Column(
          children: [
            DropdownButtonFormField(
              value: selectedBaudRate.value,
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
