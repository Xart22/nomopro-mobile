import 'dart:io';

import 'package:get/get.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  final Uri url = Uri.parse('https://tokopedia.link/yPY3uuba4zb');
  var title = 'Nomokit'.obs;
  var file = [].obs;
  Future<void> openShop() async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  askPermision() async {
    var storageStatus = await Permission.storage.status;
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
    if (!microphoneStatus.isGranted) {
      await Permission.microphone.request();
    }
  }

  getSavedProjectList() async {
    var directory = (await getExternalStorageDirectory())!.path;
    Directory savedDir = Directory("$directory/saved");
    if (!savedDir.existsSync()) {
      savedDir.createSync(recursive: true);
    }
    file.value = Directory("$directory/saved").listSync();
  }

  @override
  void onInit() {
    super.onInit();

    askPermision();
    getSavedProjectList();
  }
}
