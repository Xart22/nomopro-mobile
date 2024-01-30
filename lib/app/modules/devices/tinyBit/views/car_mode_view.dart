import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tiny_bit_controller.dart';

class CarMode extends GetView<TinyBitController> {
  const CarMode({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => Expanded(
              child: GestureDetector(
                onTap: () {
                  if (controller.trackingMode.value) {
                    controller.trackingMode.value = false;
                    controller.obstacleAvoidanceMode.value = false;
                    controller.followingMode.value = false;
                    controller.sendData("V#");
                  } else {
                    controller.trackingMode.value = true;
                    controller.obstacleAvoidanceMode.value = false;
                    controller.followingMode.value = false;
                    controller.sendData("S#");
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: controller.trackingMode.value
                        ? Colors.green
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 120.0,
                  width: 120.0,
                  child: const Center(
                    child: Text(
                      "Tracking Mode",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )),
        const SizedBox(width: 10.0),
        Obx(() => Expanded(
              child: GestureDetector(
                onTap: () {
                  if (controller.obstacleAvoidanceMode.value) {
                    controller.trackingMode.value = false;
                    controller.obstacleAvoidanceMode.value = false;
                    controller.followingMode.value = false;
                    controller.sendData("V#");
                  } else {
                    controller.trackingMode.value = false;
                    controller.obstacleAvoidanceMode.value = true;
                    controller.followingMode.value = false;
                    controller.sendData("T#");
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: controller.obstacleAvoidanceMode.value
                        ? Colors.green
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 120.0,
                  width: 120.0,
                  child: const Center(
                    child: Text(
                      "Obstacle Avoidance Mode",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )),
        const SizedBox(width: 10.0),
        Obx(() => Expanded(
              child: GestureDetector(
                onTap: () {
                  if (controller.followingMode.value) {
                    controller.trackingMode.value = false;
                    controller.obstacleAvoidanceMode.value = false;
                    controller.followingMode.value = false;
                    controller.sendData("V#");
                  } else {
                    controller.trackingMode.value = false;
                    controller.obstacleAvoidanceMode.value = false;
                    controller.followingMode.value = true;
                    controller.sendData("U#");
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: controller.followingMode.value
                        ? Colors.green
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 120.0,
                  width: 120.0,
                  child: const Center(
                    child: Text(
                      "Following Mode",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
