import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tiny_bit_controller.dart';

class CarLightView extends GetView<TinyBitController> {
  const CarLightView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCard('Red', "G#", color: Colors.red),
        const SizedBox(width: 10.0),
        _buildCard('Green', "H#", color: Colors.green),
        const SizedBox(width: 10.0),
        _buildCard('Blue', "I#", color: Colors.blue),
        const SizedBox(width: 10.0),
        _buildCard('Yellow', "J#", color: Colors.yellow),
        const SizedBox(width: 10.0),
        _buildCard('Cyan', "K#", color: Colors.cyan),
        const SizedBox(width: 10.0),
        _buildCard('Pink', "L#", color: Colors.pink),
        const SizedBox(width: 10.0),
        _buildCard('Close', "M#", color: Colors.grey),
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
