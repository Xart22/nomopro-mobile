import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:nomokit/app/services/blue_serial.dart';

import 'app/routes/app_pages.dart';
import 'app/services/usb_serial.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft]);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Nomokit",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
