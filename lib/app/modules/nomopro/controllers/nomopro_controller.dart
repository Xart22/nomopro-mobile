import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:nomokit/app/services/blue_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class NomoproController extends GetxController {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  var isLoading = true.obs;
  var isLoadedProject = false.obs;
  var projectBlop = '';
  var imageBlop = [];
  TextEditingController projectNameController = TextEditingController();
  BlueSerialService bluetoothService = Get.find<BlueSerialService>();
  var connectionTo = ''.obs;
  var devicesBt = <Device>[].obs;
  var isDiscovering = false.obs;

  createFileFromBase64(
      String base64content, String fileName, String extension) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    var bytes = base64Decode(base64content.replaceAll('\n', ''));
    final output = await getApplicationDocumentsDirectory();

    var dir = await Directory("${output.path}/saved").create(recursive: true);
    final file = File("${dir.path}/$fileName.$extension");

    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

    if (extension != 'ob') {
      Get.snackbar("Saved", "Project Saved Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    }
  }

  showConnectionModal() async {
    await bluetoothService.init();

    if (!bluetoothService.bluetoothEnabled) {
      Get.snackbar("Bluetooth", "Please enable Bluetooth",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    startDiscovery();
  }

  void startDiscovery() async {
    if (connectionTo.value == '') {
      devicesBt.clear();
      if (!isDiscovering.value) {
        isDiscovering.value = true;
        devicesBt.value = await bluetoothService.startDiscovery();
        isDiscovering.value = false;
      }
      Get.defaultDialog(
          title: connectionTo.value == ''
              ? "Connect to Device"
              : "Connected To ${connectionTo.value}",
          content: Obx(() => SizedBox(
                height: Get.height / 2,
                width: Get.width / 2,
                child: ListView.builder(
                    itemCount: devicesBt.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          Get.back();
                          await bluetoothService.disconnect();

                          bool connected = await bluetoothService.connect(
                              devicesBt[index].address, onDataReceived);

                          if (connected) {
                            connectionTo.value = devicesBt[index].name ?? '';
                            await webViewController!.postWebMessage(
                                message: WebMessage(data: 'CONNECTED'),
                                targetOrigin: WebUri('*'));
                            Get.snackbar("Bluetooth", "Connected Successfully",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2));
                          }
                        },
                        title: Text(devicesBt[index].name ?? 'Unknown'),
                        subtitle: Text(devicesBt[index].address),
                      );
                    }),
              )),
          cancel: TextButton(
            onPressed: () {
              isDiscovering.value = false;
              Get.back();
            },
            child: const Text("Cancel"),
          ),
          barrierDismissible: false);
    } else {
      Get.dialog(AlertDialog(
        title: const Text("Disconnect"),
        content: Text(
            "Are you sure you want to disconnect from ${connectionTo.value} ?"),
        actions: [
          TextButton(
            onPressed: () async {
              await bluetoothService.disconnect();
              connectionTo.value = '';
              Get.back();
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("No"),
          ),
        ],
      ));
    }
  }

  void onDataReceived(Uint8List data) async {
    final base64Str = base64.encode(data);
    await webViewController!.postWebMessage(
        message: WebMessage(data: base64Str), targetOrigin: WebUri('*'));
  }

  void writeToTransport(Uint8List data) async {
    bluetoothService.write(data);
  }

  showModalTitleProjcet(String projectBlop) {
    return Get.defaultDialog(
        title: "Save Project",
        content: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.width / 2.5,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: projectNameController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Project Name',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        if (!isLoadedProject.value) {
                          projectNameController.clear();
                        }
                        Get.back();
                      },
                      child: const Text("Cancel")),
                  ElevatedButton(
                      onPressed: () async {
                        if (projectNameController.text.isNotEmpty) {
                          Get.back();
                          await createFileFromBase64(
                              projectBlop, projectNameController.text, 'ob');
                          await createFileFromBase64(
                              imageBlop[0], projectNameController.text, 'png');
                          if (!isLoadedProject.value) {
                            projectNameController.clear();
                          }
                        }
                      },
                      child: const Text("Save")),
                ],
              ),
            ],
          ),
        ),
        barrierDismissible: false);
  }

  @override
  void onInit() {
    super.onInit();
    projectBlop = Get.arguments != null ? Get.arguments[1] : 'null';
    projectNameController.text =
        Get.arguments != null ? Get.arguments[0].split('.').first : '';
    isLoadedProject.value = Get.arguments != null ? true : false;
  }
}
