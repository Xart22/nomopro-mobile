import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/blue_serial.dart';
import '../../../../services/usb_serial.dart';

class JoystickController extends GetxController {
  final bluetoothService = Get.find<BlueSerialService>();
  final usbSerialService = Get.find<UsbSerialService>();
  var device = Get.arguments;
  var isLoading = true.obs;
  var selectedBaudRate = 9600.obs;

  var title = "".obs;
  var tittle = 'Joystick'.obs;
  var aBtnCommand = "A".obs;
  var bBtnCommand = "B".obs;
  var cBtnCommand = "C".obs;
  var dBtnCommand = "D".obs;
  var upBtnCommand = "UP".obs;
  var downBtnCommand = "DOWN".obs;
  var leftBtnCommand = "LEFT".obs;
  var rightBtnCommand = "RIGHT".obs;
  TextEditingController comandBtn = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (device[0] != 'usb') {
      title.value = device[1].name;
      connecToDeviceBle();
    } else {
      title.value = device[1].productName ?? '';
      selectedBaudRate.value = device[2];
      connectToUsb();
    }
  }

  // USB DEVICE
  connectToUsb() async {
    await usbSerialService.connect(device[1], selectedBaudRate.value, null);
    isLoading.value = false;
  }

  sendMessageUsb(String text) async {
    if (text.isNotEmpty) {
      text = text.trim();
      try {
        await usbSerialService.connectedPort!
            .write(Uint8List.fromList(utf8.encode("$text\r\n")));
      } catch (e, stacktrace) {
        print(stacktrace);
        print("Error sending message: $e");
      }
    }
  }

  // BLUETOOTH DEVICE

  connecToDeviceBle() async {
    if (bluetoothService.connection == null) {
      await bluetoothService.connect(device[1].address, null);
      if (bluetoothService.connection != null) {
        isLoading.value = false;
      }
    }
  }

  sendMessage(String text) async {
    text = text.trim();

    if (text.isNotEmpty) {
      try {
        bluetoothService.connection!.output
            .add(Uint8List.fromList(utf8.encode("$text\r\n")));
        await bluetoothService.connection!.output.allSent;
      } catch (e, stacktrace) {
        print(stacktrace);
        print("Error sending message: $e");
      }
    }
  }

  showDialogModal(String btnName) {
    comandBtn.clear();
    switch (btnName) {
      case 'A Button':
        Get.defaultDialog(
          title: 'Set $btnName Command',
          content: TextField(
            controller: comandBtn..text = aBtnCommand.value,
          ),
          confirmTextColor: Colors.white,
          onConfirm: () {
            if (comandBtn.text.isNotEmpty) {
              aBtnCommand.value = comandBtn.text;
              Get.back();
            }
          },
          onCancel: () {},
        );
        break;
      case 'B Button':
        Get.defaultDialog(
          title: 'Set Command',
          content: TextField(
            controller: comandBtn..text = bBtnCommand.value,
          ),
          confirmTextColor: Colors.white,
          onConfirm: () {
            if (comandBtn.text.isNotEmpty) {
              bBtnCommand.value = comandBtn.text;
              Get.back();
            }
          },
          onCancel: () {},
        );
        break;
      case 'C Button':
        Get.defaultDialog(
          title: 'Set Command',
          content: TextField(
            controller: comandBtn..text = cBtnCommand.value,
          ),
          confirmTextColor: Colors.white,
          onConfirm: () {
            if (comandBtn.text.isNotEmpty) {
              cBtnCommand.value = comandBtn.text;
              Get.back();
            }
          },
          onCancel: () {},
        );
        break;
      case 'D Button':
        Get.defaultDialog(
          title: 'Set Command',
          content: TextField(
            controller: comandBtn..text = dBtnCommand.value,
          ),
          confirmTextColor: Colors.white,
          onConfirm: () {
            if (comandBtn.text.isNotEmpty) {
              dBtnCommand.value = comandBtn.text;
              Get.back();
            }
          },
          onCancel: () {},
        );
        break;
      case 'Arrow Up Button':
        Get.defaultDialog(
          title: 'Set Command',
          content: TextField(
            controller: comandBtn..text = upBtnCommand.value,
          ),
          confirmTextColor: Colors.white,
          onConfirm: () {
            if (comandBtn.text.isNotEmpty) {
              upBtnCommand.value = comandBtn.text;
              Get.back();
            }
          },
          onCancel: () {},
        );
        break;
      case 'Arrow Right Button':
        Get.defaultDialog(
          title: 'Set Command',
          content: TextField(
            controller: comandBtn..text = rightBtnCommand.value,
          ),
          confirmTextColor: Colors.white,
          onConfirm: () {
            if (comandBtn.text.isNotEmpty) {
              rightBtnCommand.value = comandBtn.text;
              Get.back();
            }
          },
          onCancel: () {},
        );
        break;
      case 'Arrow Down Button':
        Get.defaultDialog(
            title: 'Set Command',
            content: TextField(
              controller: comandBtn..text = downBtnCommand.value,
            ),
            confirmTextColor: Colors.white,
            onConfirm: () {
              if (comandBtn.text.isNotEmpty) {
                downBtnCommand.value = comandBtn.text;
                Get.back();
              }
            },
            onCancel: () {});
        break;
      case 'Arrow Left Button':
        Get.defaultDialog(
            title: 'Set Command',
            content: TextField(
              controller: comandBtn..text = leftBtnCommand.value,
            ),
            confirmTextColor: Colors.white,
            onConfirm: () {
              if (comandBtn.text.isNotEmpty) {
                leftBtnCommand.value = comandBtn.text;
                Get.back();
              }
            },
            onCancel: () {});
        break;
    }
  }

  @override
  void onClose() {
    bluetoothService.disconnect();
    usbSerialService.disconnect();
    super.onClose();
  }
}
