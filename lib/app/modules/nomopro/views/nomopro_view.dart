import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';

import '../controllers/nomopro_controller.dart';

class NomoproView extends GetView<NomoproController> {
  const NomoproView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InAppWebView(
      initialUrlRequest: URLRequest(
          url: WebUri(
              "http://localhost:8080/?project_file=" + controller.projectBlop)),
      onConsoleMessage: (ctr, consoleMessage) {
        print(consoleMessage);
      },
      onPermissionRequest: (ctr, request) async {
        return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT);
      },
      onWebViewCreated: (ctr) async {
        ctr.addJavaScriptHandler(
          handlerName: "blobToBase64Handler",
          callback: (data) async {
            if (data.isNotEmpty) {
              final String receivedFileInBase64 = data[0];
              controller.createFileFromBase64(
                  receivedFileInBase64, controller.projectName.value, 'ob');
            }
          },
        );
      },
      onDownloadStartRequest: (ctr, blopRes) async {
        var jsContent =
            await rootBundle.loadString("assets/gui/project-downloader.js");
        await ctr.evaluateJavascript(
            source: jsContent.replaceAll(
                "blobUrlPlaceholder", blopRes.url.toString()));
      },
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        supportZoom: false,
        preferredContentMode: UserPreferredContentMode.MOBILE,
        useOnDownloadStart: true,
      ),
    ));
  }
}
