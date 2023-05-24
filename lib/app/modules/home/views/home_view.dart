import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nomokit'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed("/settings");
            },
            icon: const Icon(
              Icons.account_circle,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed("/settings");
            },
            icon: const Icon(
              Icons.settings,
              size: 30,
            ),
          ),
        ],
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
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed("/control/devices", arguments: "usb");
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/img/nomo.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Nomopro"),
                      ],
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
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed("/control");
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          height: 120,
                          child: Image.asset(
                            "assets/img/usb.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Control Your Device"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
