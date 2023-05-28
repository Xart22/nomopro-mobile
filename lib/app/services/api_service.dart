import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../data/login_response_model.dart';

class ApiService {
  static final client = http.Client();
  static final storage = GetStorage();
  static String accestoken = storage.read('accestoken');

  static Future<bool?> login(String username, String password) async {
    try {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? token = await firebaseMessaging.getToken();
      final response =
          await client.post(Uri.parse('https://nomo-kit.com/api/login'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: json.encode({
                'appFrom': 'android',
                'email': username,
                'password': password,
                'fcm_token': token,
              }));
      if (response.statusCode == 200) {
        final data = loginResponseModelFromJson(response.body);
        await storage.write('accestoken', data.token);
        if (data.user.subscriptions == null) {
          Get.snackbar(
            'Failed',
            'You are not subscribed to any plan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
          );
          await logout();
          return false;
        }
        await storage.write('user', data.user.toJson());

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateFcm(String token) async {
    await getAccesToken();
    try {
      final response = await client
          .post(Uri.parse('https://nomo-kit.com/api/login'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $accestoken',
              },
              body: json.encode({
                'fcm_token': token,
              }))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan');
    }
  }

  static Future<bool> logout() async {
    await getAccesToken();
    try {
      final response = await client.get(
        Uri.parse('https://nomo-kit.com/api/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        },
      );
      if (response.statusCode == 200) {
        await storage.erase();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan');
    }
  }

  static getAccesToken() async {
    accestoken = await storage.read('accestoken');
  }

  static Future<bool?> getProfile() async {
    await getAccesToken();
    try {
      final response = await client.get(
        Uri.parse('https://nomo-kit.com/api/user'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        },
      );

      if (response.statusCode == 200) {
        final data = loginResponseModelFromJson(response.body);
        await storage.write('accestoken', data.token);
        if (data.user.subscriptions == null) {
          Get.snackbar(
            'Failed',
            'You are not subscribed to any plan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
          );
          await logout();
          return false;
        }
        await storage.write('user', data.user.toJson());

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
