import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nomokit/app/modules/devices/tinyBit/views/car_light_view.dart';
import 'package:nomokit/app/modules/devices/tinyBit/views/car_mode_view.dart';
import 'package:nomokit/app/modules/devices/tinyBit/views/car_rgb_view.dart';
import 'package:nomokit/app/modules/loading.dart';

import '../controllers/tiny_bit_controller.dart';
import 'car_music_view.dart';

class TinyBitView extends GetView<TinyBitController> {
  const TinyBitView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TinyBitView'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.blueGrey[200],
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                  'Distance : ${controller.ultraSonic.value} cm',
                                  style: const TextStyle(fontSize: 16))),
                              Obx(() => Text(
                                  'Temperature : ${controller.temperature.value} °C',
                                  style: const TextStyle(fontSize: 16))),
                            ]),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTapCancel: () =>
                                        {controller.sendData("0#")},
                                    onTapDown: (details) =>
                                        {controller.sendData("A#")},
                                    child: IconButton(
                                        splashColor: Colors.blueAccent,
                                        iconSize: 45,
                                        onPressed: () {},
                                        icon: Image.asset(
                                          'assets/img/arrow_up_green.png',
                                        )),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTapCancel: () =>
                                        {controller.sendData("0#")},
                                    onTapDown: (details) =>
                                        {controller.sendData("C#")},
                                    child: IconButton(
                                        splashColor: Colors.blueAccent,
                                        iconSize: 45,
                                        onPressed: () {},
                                        icon: Image.asset(
                                          'assets/img/arrow_left_yellow.png',
                                        )),
                                  ),
                                  SizedBox(width: Get.width * 0.08),
                                  GestureDetector(
                                    onTapCancel: () =>
                                        {controller.sendData("0#")},
                                    onTapDown: (details) =>
                                        {controller.sendData("D#")},
                                    child: IconButton(
                                        splashColor: Colors.blueAccent,
                                        iconSize: 45,
                                        onPressed: () {},
                                        icon: Image.asset(
                                          'assets/img/arrow_right_yellow.png',
                                        )),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTapCancel: () =>
                                        {controller.sendData("0#")},
                                    onTapDown: (details) =>
                                        {controller.sendData("B#")},
                                    child: IconButton(
                                        splashColor: Colors.blueAccent,
                                        iconSize: 45,
                                        onPressed: () {},
                                        icon: Image.asset(
                                          'assets/img/arrow_down_red.png',
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: Get.width * 0.2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTapCancel: () =>
                                          {controller.sendData("0#")},
                                      onTapDown: (details) =>
                                          {controller.sendData("E#")},
                                      child: IconButton(
                                          splashColor: Colors.blueAccent,
                                          iconSize: 45,
                                          onPressed: () {},
                                          icon: Image.asset(
                                            'assets/img/rotate-left.png',
                                          )),
                                    ),
                                    GestureDetector(
                                      onTapCancel: () =>
                                          {controller.sendData("0#")},
                                      onTapDown: (details) =>
                                          {controller.sendData("F#")},
                                      child: IconButton(
                                          splashColor: Colors.blueAccent,
                                          iconSize: 45,
                                          onPressed: () {},
                                          icon: Image.asset(
                                            'assets/img/rotate-right.png',
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffE8EDF1)),
                          child: TabBar(
                              controller: controller.tabController,
                              tabs: controller.listTab,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.black,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 2),
                                        blurRadius: 2)
                                  ])),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffE8EDF1)),
                            child: TabBarView(
                              controller: controller.tabController,
                              children: const [
                                CarMusicView(),
                                CarLightView(),
                                CarRGB(),
                                CarMode(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Obx(() =>
                controller.isScanning.value ? const Loading() : Container()),
          ],
        ));
  }
}
