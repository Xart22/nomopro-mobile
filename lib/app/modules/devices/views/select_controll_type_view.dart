import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/devices_controller.dart';

class SelectControllTypeView extends GetView<DevicesController> {
  const SelectControllTypeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF4d97ff),
          title: const Text('Controll Type'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCard("assets/img/joystick.png", '/devices/joystick'),
                // _buildCard("assets/img/button.png", '/devices/button'),
                _buildCard("assets/img/chat.png", '/devices/chat'),
              ],
            ),
          ),
        ));
  }

  Widget _buildCard(String image, String route) {
    return SizedBox(
      width: Get.width / 3.5,
      height: Get.height / 2.5,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.grey, width: 2),
        ),
        elevation: 5,
        child: InkWell(
          onTap: () {
            if (controller.connectionType == 'usb') {
              controller.showModalBaudRate(route);
            } else {
              Get.toNamed(route, arguments: [
                controller.connectionType,
                controller.devicesBt[controller.indexSelected.value].device
              ]);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
