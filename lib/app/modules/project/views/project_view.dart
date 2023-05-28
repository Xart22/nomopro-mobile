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
        title: const Text('My Space'),
        centerTitle: true,
      ),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.count(
              crossAxisCount: 5,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: List.generate(controller.file.length, (index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
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
                            controller.createFileFromPath(
                                controller.file[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Text(controller.file[0].path.split('/').last,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          )),
    );
  }
}
