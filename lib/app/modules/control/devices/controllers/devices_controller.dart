import 'dart:async';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:nomokit/app/services/blue_serial.dart';
import 'package:nomokit/app/services/usb_serial.dart';

class DevicesController extends GetxController {
  var connectionType = Get.arguments;
  final usbService = Get.find<UsbSerialService>();
  final bluetoothService = Get.find<BlueSerialService>();
  var devicesUsb = <Widget>[].obs;
  var title = "Select Device".obs;
  BluetoothConnection? connection;
  var messages = <Message>[].obs;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  var chat = <Row>[].obs;

  StreamSubscription<BluetoothDiscoveryResult>? streamSubscription;
  String? address;
  String? name;
  var devicesBt = <BluetoothDiscoveryResult>[].obs;
  var isDiscovering = true.obs;
  var messageBuffer = ''.obs;
  var clientID = 0;

  Timer? discoverableTimeoutTimer;
  int discoverableTimeoutSecondsLeft = 0;

  startDiscovery() {
    title.value = "Discovering Devices";
    streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      devicesBt.add(r);
    });

    streamSubscription!.onDone(() {
      title.value = "Select Bluetooth Device";
      isDiscovering.value = false;
    });
  }

  restartDiscovery() {
    devicesBt.clear();
    isDiscovering.value = true;

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
      if (bluetoothService.bluetoothState == BluetoothState.STATE_OFF) {
        await FlutterBluetoothSerial.instance
            .requestEnable()
            .then((value) async {
          if (value == true) {
            startDiscovery();
          } else {
            Get.back();
            Get.snackbar("Bluetooth", "Bluetooth is not enabled",
                snackPosition: SnackPosition.BOTTOM);
          }
        });
      } else {
        startDiscovery();
      }
    }
  }

  connect(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');

      connection?.input?.listen(onDataReceived).onDone(() {
        print('Disconnected by remote request');
      });
    } catch (exception) {
      print('Cannot connect, exception occured');
    }
  }

  void onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);

    if (~index != 0) {
      messages.add(
        Message(
          1,
          backspacesCounter > 0
              ? messageBuffer.value
                  .substring(0, messageBuffer.value.length - backspacesCounter)
              : messageBuffer.value + dataString.substring(0, index),
        ),
      );
      messageBuffer.value = dataString.substring(index);
    } else {
      messageBuffer.value = (backspacesCounter > 0
          ? messageBuffer.value
              .substring(0, messageBuffer.value.length - backspacesCounter)
          : messageBuffer.value + dataString);
    }
    chat.value = messages.map((message) {
      Future.delayed(const Duration(milliseconds: 333)).then((_) {
        listScrollController.animateTo(
            listScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 333),
            curve: Curves.easeOut);
      });
      return Row(
        mainAxisAlignment: message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: Get.width / 4.5, //ex 222
            decoration: BoxDecoration(
                color:
                    message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(message.text.trim()),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      );
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    if (connectionType != 'usb') {
      title.value = "Select Bluetooth Device";
    }
    getDevices();
  }

  @override
  void onClose() {
    super.onClose();
    streamSubscription?.cancel();
    connection?.close();
  }
}

class Message {
  int whom;
  String text;

  Message(this.whom, this.text);
}
