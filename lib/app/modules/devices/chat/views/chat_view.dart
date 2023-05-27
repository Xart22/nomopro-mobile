import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nomokit/app/modules/loading.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat With ${controller.title.value}"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4d97ff),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                iconSize: 30,
                icon: Image.asset(
                  'assets/img/trash.png',
                  color: Colors.white,
                ),
                onPressed: () {
                  controller.chat.clear();
                  controller.messages.clear();
                }),
          ),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? const Loading()
          : Column(
              children: [
                GetBuilder<ChatController>(
                  builder: (_) {
                    return Flexible(
                        child: ListView(
                      padding: const EdgeInsets.all(12.0),
                      controller: controller.listScrollController,
                      children: controller.chat,
                    ));
                  },
                ),
                Row(
                  children: [
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
                      padding:
                          const EdgeInsets.only(right: 50, top: 10, bottom: 10),
                      child: IconButton(
                          icon: const Icon(
                            Icons.send,
                            size: 40,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            controller.sendMessage(
                                controller.textEditingController.text);
                          }),
                    ),
                  ],
                )
              ],
            )),
    );
  }
}
