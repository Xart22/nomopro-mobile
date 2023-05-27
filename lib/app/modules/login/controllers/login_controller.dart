import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nomokit/app/modules/devices/views/arrow_keys_view.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var buttonEnabled = false.obs;
  var isLoading = false.obs;
  var isShowPassword = false.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;

  void submit() {
    if (emailController.text == '') {
      emailError.value = 'Email is required';
    }
    if (passwordController.text == '') {
      passwordError.value = 'Password is required';
    }
    if (emailController.text != '' && passwordController.text != '') {
      Get.offAllNamed('/home');
    }
    Get.to(() => const ArrowKeysView());
  }

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      if (emailController.text == '') {
        emailError.value = '';
      } else {
        if (GetUtils.isEmail(emailController.text)) {
          emailError.value = '';
        } else {
          emailError.value = 'Email is not valid';
        }
      }
    });
    passwordController.addListener(() {
      if (passwordController.text == '') {
        passwordError.value = '';
      } else {
        if (passwordController.text.length < 6) {
          passwordError.value = 'Password must be at least 6 characters';
        } else {
          passwordError.value = '';
        }
      }
    });
  }
}
