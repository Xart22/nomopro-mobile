import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tiny_bit_controller.dart';

class CarRGB extends GetView<TinyBitController> {
  const CarRGB({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCard('Following Light', "N#", color: Colors.red),
        const SizedBox(width: 10.0),
        _buildCard('Marquee Light', "P#", color: Colors.green),
        const SizedBox(width: 10.0),
        _buildCard('Breathe Light', "Q#", color: Colors.blue),
        const SizedBox(width: 10.0),
        _buildCard('Change Color', "R#", color: Colors.yellow),
        const SizedBox(width: 10.0),
        _buildCard('Turn Off', "W#", color: Colors.grey),
      ],
    );
  }

  Widget _buildCard(String colorName, String comand, {Color? color}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => {controller.sendData(comand)},
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 120.0,
          child: Center(
            child: Text(
              colorName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
