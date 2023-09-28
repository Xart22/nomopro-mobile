import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nomokit/app/data/proejct_categories_model.dart';
import 'package:nomokit/app/services/api_service.dart';
import 'package:share_plus/share_plus.dart';

class UploadProjectController extends GetxController {
  var file = XFile(Get.arguments).obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController desc = TextEditingController();
  var isLoading = false.obs;

  var selectedCategory = 0.obs;
  var titleError = ''.obs;
  var list = <ProjectCategory>[].obs;

  void submit() {}

  void getCategories() async {
    await ApiService.getProjectCategories()
        .then((value) => list.value = value!);
  }

  @override
  void onInit() {
    getCategories();
    titleController.text = file.value.name.replaceAll(".ob", "");
    super.onInit();
  }
}
