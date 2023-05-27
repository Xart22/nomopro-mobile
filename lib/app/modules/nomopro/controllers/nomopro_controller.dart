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
  var projectName = ''.obs;
  var projectBlop = Get.arguments;

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
  }
}