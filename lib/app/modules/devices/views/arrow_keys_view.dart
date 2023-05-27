import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/devices_controller.dart';

class ArrowKeysView extends GetView<DevicesController> {
  const ArrowKeysView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Arrow Keys')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: Get.width / 3,
                    height: Get.height / 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            splashColor: Colors.blueAccent,
                            iconSize: 60,
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/img/arrow_up.png',
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                child: IconButton(
                                    splashColor: Colors.blueAccent,
                                    iconSize: 60,
                                    onPressed: () {},
                                    icon: Image.asset(
                                      'assets/img/arrow_left.png',
                                    ))),
                            const SizedBox(),
                            SizedBox(
                                child: IconButton(
                                    splashColor: Colors.blueAccent,
                                    iconSize: 60,
                                    onPressed: () {},
                                    icon: Image.asset(
                                      'assets/img/arrow_right.png',
                                    ))),
                          ],
                        ),
                        SizedBox(
                            child: IconButton(
                                splashColor: Colors.blueAccent,
                                iconSize: 60,
                                onPressed: () {},
                                icon: Image.asset(
                                  'assets/img/arrow_down.png',
                                ))),
                      ],
                    )),
                Container(
                    width: Get.width / 4,
                    height: Get.height / 1.5,
                    decoration: BoxDecoration(
                        border: Border.all(width: 3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        // Flexible(
                        //     child: Obx(
                        //   () => ListView(
                        //       controller: controller.listScrollController,
                        //       children: controller.chat),
                        // ))
                      ],
                    )),
                SizedBox(
                    width: Get.width / 3,
                    height: Get.height / 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 3),
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                              splashColor: Colors.blueAccent,
                              iconSize: 40,
                              onPressed: () {},
                              icon: const Text('B',
                                  style: TextStyle(fontSize: 30))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 3),
                                  borderRadius: BorderRadius.circular(100)),
                              child: IconButton(
                                  splashColor: Colors.blueAccent,
                                  iconSize: 40,
                                  onPressed: () {},
                                  icon: const Text('A',
                                      style: TextStyle(fontSize: 30))),
                            ),
                            const SizedBox(),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 3),
                                  borderRadius: BorderRadius.circular(100)),
                              child: IconButton(
                                  splashColor: Colors.blueAccent,
                                  iconSize: 40,
                                  onPressed: () {},
                                  icon: const Text('C',
                                      style: TextStyle(fontSize: 30))),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 3),
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                              iconSize: 40,
                              splashColor: Colors.blueAccent,
                              onPressed: () {},
                              icon: const Text('D',
                                  style: TextStyle(fontSize: 30))),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
