import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

InAppLocalhostServer localhostServer =
    InAppLocalhostServer(documentRoot: 'assets/gui');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft]);
  await localhostServer.start();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Nomokit",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
