import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'control_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4d97ff),
        title: Obx(() => Text(controller.title.value)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed("/profile");
            },
            icon: const Icon(
              Icons.account_circle,
              size: 30,
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     Get.toNamed("/settings");
          //   },
          //   icon: const Icon(
          //     Icons.settings,
          //     size: 30,
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/nomopro");
        },
        child: const Icon(Icons.play_arrow, size: 40),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => SizedBox(
                    width: Get.width / 3.5,
                    height: Get.height / 2.5,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.grey, width: 2),
                      ),
                      child: InkWell(
                        onTap: () {
                          controller.file.isEmpty
                              ? Get.snackbar("No Saved Project",
                                  "Please save your project first",
                                  snackPosition: SnackPosition.BOTTOM)
                              : Get.toNamed("/project");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            image: DecorationImage(
                              opacity: controller.file.isEmpty ? 0.5 : 1,
                              image:
                                  const AssetImage("assets/img/playground.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                width: Get.width / 3.5,
                height: Get.height / 2.5,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const ControlView());
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        image: DecorationImage(
                          image: AssetImage("assets/img/controller.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Get.width / 3.5,
                height: Get.height / 2.5,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  child: InkWell(
                    onTap: () {
                      controller.openShop();
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        image: DecorationImage(
                          image: AssetImage("assets/img/shop.png"),
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
    );
  }
}
