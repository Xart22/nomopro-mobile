import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
    print(file);
  }

  onProjectLoaded(String path) async {
    File file = File(path);
    Uint8List bytes = await file.readAsBytes();
    String base64 = base64Encode(bytes);
    Get.toNamed('/nomopro', arguments: base64);
  }

  @override
  void onInit() {
    super.onInit();

    askPermision();
    getSavedProjectList();
  }
}
