import 'dart:io';

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
    String content = await file.readAsBytes().then((value) => value.toString());
    Get.toNamed('/nomopro', arguments: content);
  }

  @override
  void onInit() {
    super.onInit();

    askPermision();
    getSavedProjectList();
  }
}
