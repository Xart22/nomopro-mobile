import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ButtonView extends GetView {
  const ButtonView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ButtonView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ButtonView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
