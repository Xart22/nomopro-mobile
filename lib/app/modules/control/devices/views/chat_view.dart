import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/devices_controller.dart';

class ChatView extends GetView<DevicesController> {
  const ChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatView'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: Obx(
              () => ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: controller.listScrollController,
                  children: controller.chat),
            )),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      style: const TextStyle(fontSize: 15.0),
                      controller: controller.textEditingController,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child:
                      IconButton(icon: const Icon(Icons.send), onPressed: null),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
