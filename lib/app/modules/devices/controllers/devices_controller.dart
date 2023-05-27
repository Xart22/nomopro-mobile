import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:nomokit/app/services/blue_serial.dart';
import 'package:nomokit/app/services/usb_serial.dart';

class DevicesController extends GetxController {
  var connectionType = Get.arguments;
  var title = "Select Device".obs;

  // USB
  late UsbSerialService usbService;
  var devicesUsb = <Widget>[].obs;
  // BLE
  late BlueSerialService bluetoothService;
  StreamSubscription<BluetoothDiscoveryResult>? deviceStreamSubscription;
  var isDiscovering = true.obs;
  var devicesBt = <BluetoothDiscoveryResult>[].obs;
  var messages = <Message>[].obs;
  final TextEditingController textEditingController = TextEditingController();
  var indexSelected = 0.obs;

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
      await usbService.getPorts();
      devicesUsb.clear();
      devicesUsb.addAll(usbService.ports);
    } else {
      bluetoothService.init();
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
      } else {}
    }
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
