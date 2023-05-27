import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nomokit/app/modules/loading.dart';

import '../controllers/joystick_controller.dart';

class JoystickView extends GetView<JoystickController> {
  const JoystickView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Joystick For ${controller.title.value}"),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Obx(() => controller.isLoading.value
            ? const Loading()
            : Center(
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
                                  onPressed: () {
                                    if (controller.device[0] == 'usb') {
                                      controller.sendMessageUsb(
                                          controller.upBtnCommand.value);
                                    } else {
                                      controller.sendMessage(
                                          controller.upBtnCommand.value);
                                    }
                                  },
                                  icon: Image.asset(
                                    'assets/img/arrow_up.png',
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                      child: IconButton(
                                          splashColor: Colors.blueAccent,
                                          iconSize: 60,
                                          onPressed: () {
                                            if (controller.device[0] == 'usb') {
                                              controller.sendMessageUsb(
                                                  controller
                                                      .leftBtnCommand.value);
                                            } else {
                                              controller.sendMessage(controller
                                                  .leftBtnCommand.value);
                                            }
                                          },
                                          icon: Image.asset(
                                            'assets/img/arrow_left.png',
                                          ))),
                                  const SizedBox(),
                                  SizedBox(
                                      child: IconButton(
                                          splashColor: Colors.blueAccent,
                                          iconSize: 60,
                                          onPressed: () {
                                            if (controller.device[0] == 'usb') {
                                              controller.sendMessageUsb(
                                                  controller
                                                      .rightBtnCommand.value);
                                            } else {
                                              controller.sendMessage(controller
                                                  .rightBtnCommand.value);
                                            }
                                          },
                                          icon: Image.asset(
                                            'assets/img/arrow_right.png',
                                          ))),
                                ],
                              ),
                              SizedBox(
                                  child: IconButton(
                                      splashColor: Colors.blueAccent,
                                      iconSize: 60,
                                      onPressed: () {
                                        if (controller.device[0] == 'usb') {
                                          controller.sendMessageUsb(
                                              controller.downBtnCommand.value);
                                        } else {
                                          controller.sendMessage(
                                              controller.downBtnCommand.value);
                                        }
                                      },
                                      icon: Image.asset(
                                        'assets/img/arrow_down.png',
                                      ))),
                            ],
                          )),
                      Container(
                          width: Get.width / 4,
                          height: Get.height / 1.5,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Obx(() => ListView(
                                children: [
                                  ListTile(
                                    title: const Text('A Button'),
                                    subtitle: Text(
                                        'comand : ${controller.aBtnCommand.value}'),
                                    onTap: () {
                                      controller.showDialogModal('A Button');
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('B Button'),
                                    subtitle: Text(
                                      'comand : ${controller.bBtnCommand.value}',
                                    ),
                                    onTap: () {
                                      controller.showDialogModal('B Button');
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('C Button'),
                                    subtitle: Text(
                                        'comand : ${controller.cBtnCommand.value}'),
                                    onTap: () {
                                      controller.showDialogModal('C Button');
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('D Button'),
                                    subtitle: Text(
                                        'comand : ${controller.dBtnCommand.value}'),
                                    onTap: () {
                                      controller.showDialogModal('D Button');
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Arrow Up Button'),
                                    subtitle: Text(
                                        'comand : ${controller.upBtnCommand.value}'),
                                    onTap: () {
                                      controller
                                          .showDialogModal('Arrow Up Button');
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Arrow Right Button'),
                                    subtitle: Text(
                                        'comand : ${controller.rightBtnCommand.value}'),
                                    onTap: () {
                                      controller.showDialogModal(
                                          'Arrow Right Button');
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Arrow Down Button'),
                                    subtitle: Text(
                                        'comand : ${controller.downBtnCommand.value}'),
                                    onTap: () {
                                      controller
                                          .showDialogModal('Arrow Down Button');
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Arrow Left Button'),
                                    subtitle: Text(
                                        'comand : ${controller.leftBtnCommand.value}'),
                                    onTap: () {
                                      controller
                                          .showDialogModal('Arrow Left Button');
                                    },
                                  ),
                                ],
                              ))),
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
                                    onPressed: () {
                                      if (controller.device[0] == 'usb') {
                                        controller.sendMessageUsb(
                                            controller.bBtnCommand.value);
                                      } else {
                                        controller.sendMessage(
                                            controller.bBtnCommand.value);
                                      }
                                    },
                                    icon: const Text('B',
                                        style: TextStyle(fontSize: 30))),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 3),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: IconButton(
                                        splashColor: Colors.blueAccent,
                                        iconSize: 40,
                                        onPressed: () {
                                          if (controller.device[0] == 'usb') {
                                            controller.sendMessageUsb(
                                                controller.aBtnCommand.value);
                                          } else {
                                            controller.sendMessage(
                                                controller.aBtnCommand.value);
                                          }
                                        },
                                        icon: const Text('A',
                                            style: TextStyle(fontSize: 30))),
                                  ),
                                  const SizedBox(),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 3),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: IconButton(
                                        splashColor: Colors.blueAccent,
                                        iconSize: 40,
                                        onPressed: () {
                                          if (controller.device[0] == 'usb') {
                                            controller.sendMessageUsb(
                                                controller.cBtnCommand.value);
                                          } else {
                                            controller.sendMessage(
                                                controller.cBtnCommand.value);
                                          }
                                        },
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
                                    onPressed: () {
                                      if (controller.device[0] == 'usb') {
                                        controller.sendMessageUsb(
                                            controller.dBtnCommand.value);
                                      } else {
                                        controller.sendMessage(
                                            controller.dBtnCommand.value);
                                      }
                                    },
                                    icon: const Text('D',
                                        style: TextStyle(fontSize: 30))),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              )));
  }
}
