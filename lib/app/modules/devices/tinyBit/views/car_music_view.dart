import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tiny_bit_controller.dart';

class CarMusicView extends GetView<TinyBitController> {
  const CarMusicView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 35.0),
        width: 430,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 50.0,
                color: Colors.white,
                height: 120.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => {
                    controller.sendData("1#"),
                  },
                  child: const Center(
                    child: Text(
                      "1",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1 - 35,
              child: Container(
                width: 50.0,
                color: Colors.white,
                height: 120.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => {
                    controller.sendData("2#"),
                  },
                  child: const Center(
                    child: Text(
                      "2",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1 - 53,
              child: Container(
                width: 40.0,
                color: Colors.black,
                height: 80.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => {
                    controller.sendData("B1#"),
                  },
                  child: const Center(),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1 + 18,
              child: Container(
                width: 50.0,
                color: Colors.white,
                height: 120.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => {
                    controller.sendData("3#"),
                  },
                  child: const Center(
                    child: Text(
                      "3",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1,
              child: Container(
                width: 40.0,
                color: Colors.black,
                height: 80.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => {
                    controller.sendData("B2#"),
                  },
                  child: const Center(),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1 + 71,
              child: Container(
                width: 50.0,
                color: Colors.white,
                height: 120.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => {
                    controller.sendData("4#"),
                  },
                  child: const Center(
                    child: Text(
                      "4",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1 + 125,
              child: Container(
                width: 50.0,
                color: Colors.white,
                height: 120.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => {
                    controller.sendData("5#"),
                  },
                  child: const Center(
                    child: Text(
                      "5",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1 + 105,
              child: Container(
                width: 40.0,
                color: Colors.black,
                height: 80.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => {
                    controller.sendData("B3#"),
                  },
                  child: const Center(),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1 + 178,
              child: Container(
                width: 50.0,
                color: Colors.white,
                height: 120.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => {
                    controller.sendData("6#"),
                  },
                  child: const Center(
                    child: Text(
                      "6",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1 + 160,
              child: Container(
                width: 40.0,
                color: Colors.black,
                height: 80.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => {
                    controller.sendData("B4#"),
                  },
                  child: const Center(),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1 + 232,
              child: Container(
                width: 50.0,
                color: Colors.white,
                height: 120.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => {
                    controller.sendData("7#"),
                  },
                  child: const Center(
                    child: Text(
                      "7",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1 + 212,
              child: Container(
                width: 40.0,
                color: Colors.black,
                height: 80.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => {
                    controller.sendData("B5#"),
                  },
                  child: const Center(),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: Get.width * 0.1 + 285,
              child: Container(
                width: 50.0,
                color: Colors.white,
                height: 120.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => {
                    controller.sendData("8#"),
                  },
                  child: const Center(
                    child: Text(
                      "i",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
