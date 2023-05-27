import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/project_controller.dart';

class ProjectView extends GetView<ProjectController> {
  const ProjectView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProjectView'),
        centerTitle: true,
      ),
      body: Obx(() => GridView.count(
            crossAxisCount: 5,
            children: List.generate(controller.file.length, (index) {
              return ListTile(
                title: Text(controller.file[index].uri.toString()),
                onTap: () {
                  controller.onProjectLoaded(controller.file[index].path);
                },
              );
            }),
          )),
    );
  }
}
