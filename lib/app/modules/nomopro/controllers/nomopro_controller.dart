import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
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

    await file.writeAsBytes(bytes.buffer.asUint8List());
    if (extension == 'ob') {
      Get.snackbar("Saved", "Project Saved Successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    }
  }

  showModalTitleProjcet(String projectBlop) {
    Get.defaultDialog(
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
                          await createFileFromBase64(
                              projectBlop, projectNameController.text, 'ob');
                          await createFileFromBase64(
                              imageBlop[0], projectNameController.text, 'png');
                          if (!isLoadedProject.value) {
                            projectNameController.clear();
                          }
                          Get.back();
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
