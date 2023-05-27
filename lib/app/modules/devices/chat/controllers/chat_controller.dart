import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/message_model.dart';
import '../../../../services/blue_serial.dart';

class ChatController extends GetxController {
  final bluetoothService = Get.find<BlueSerialService>();
  var device = Get.arguments;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  var messages = <Message>[].obs;
  var chat = <Row>[].obs;
  var title = ''.obs;
  var clientID = 0.obs;
  var messageBuffer = ''.obs;
  var isLoading = true.obs;

  sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.isNotEmpty) {
      try {
        bluetoothService.connection!.output
            .add(Uint8List.fromList(utf8.encode("$text\r\n")));
        await bluetoothService.connection!.output.allSent;

        messages.add(Message(clientID.value, text));
        Future.delayed(const Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e, stacktrace) {
        print(stacktrace);
        print("Error sending message: $e");
      }
    }
  }

  connecToDeviceBle() async {
    if (bluetoothService.connection == null) {
      await bluetoothService.connect(device[1].address, onDataReceived);
      if (bluetoothService.connection != null) {
        isLoading.value = false;
      }
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
        mainAxisAlignment: message.whom == clientID.value
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222,
            decoration: BoxDecoration(
                color: message.whom == clientID.value
                    ? Colors.blueAccent
                    : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(message.text.trim()),
                style: const TextStyle(color: Colors.black)),
          ),
        ],
      );
    }).toList();
    update();
  }

  @override
  void onInit() {
    connecToDeviceBle();
    super.onInit();
    title.value = device[1].name;
  }

  @override
  void onClose() {
    bluetoothService.disconnect();
    super.onClose();
  }
}
