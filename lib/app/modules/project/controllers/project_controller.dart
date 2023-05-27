import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ProjectController extends GetxController {
  var file = <FileSystemEntity>[].obs;

  askPermision() async {
    await Permission.storage.request();
  }

  getSavedProjectList() async {
    var directory = (await getApplicationDocumentsDirectory()).path;
    Directory savedDir = Directory("$directory/saved");
    if (!savedDir.existsSync()) {
      savedDir.createSync(recursive: true);
    }
    file.value = Directory("$directory/saved").listSync();
    file.value = file.where((p0) => p0.path.contains('.ob')).toList();
  }

  onLongPress(String path) {
    Get.defaultDialog(
      title: 'Delete Project',
      middleText: 'Are you sure want to delete this project?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await deleteProject(path);
        Get.back();
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  deleteProject(String path) {
    File file = File(path);
    file.deleteSync();
    File image = File(path.replaceAll('.ob', '.png'));
    image.deleteSync();
    getSavedProjectList();
  }

  createFileFromPath(String path) {
    File file = File(path.replaceAll('.ob', '.png'));

    return file;
  }

  onProjectLoaded(String path) async {
    File file = File(path);
    Uint8List bytes = await file.readAsBytes();
    String base64 = base64Encode(bytes);

    Get.offAndToNamed('/nomopro',
        arguments: [file.path.split('/').last, base64]);
  }

  @override
  void onInit() {
    super.onInit();

    askPermision();
    getSavedProjectList();
  }
}
