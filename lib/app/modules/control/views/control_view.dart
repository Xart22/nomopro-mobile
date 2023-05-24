import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/control_controller.dart';

class ControlView extends GetView<ControlController> {
  const ControlView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Choose Connection'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 208, 208, 208), width: 3),
                    ),
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed("/control/devices", arguments: "usb");
                      },
                      child: Container(
                        width: 120,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: AssetImage("assets/img/usb.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 208, 208, 208), width: 3),
                    ),
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed("/control/devices", arguments: "bluetooth");
                      },
                      child: Container(
                        width: 120,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: AssetImage("assets/img/usb.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
