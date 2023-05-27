import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/project_controller.dart';

class ProjectView extends GetView<ProjectController> {
  const ProjectView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4d97ff),
        title: const Text('ProjectView'),
        centerTitle: true,
      ),
      body: Obx(() => GridView.count(
            crossAxisCount: 5,
            children: List.generate(controller.file.length, (index) {
              return Card(
                child: InkWell(
                  onTap: () {
                    controller.onProjectLoaded(controller.file[index].path);
                  },
                  onLongPress: () {
                    controller.onLongPress(controller.file[index].path);
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.file(
                          controller
                              .createFileFromPath(controller.file[index].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(controller.file[index].path.split('/').last),
                    ],
                  ),
                ),
              );
            }),
          )),
    );
  }
}
