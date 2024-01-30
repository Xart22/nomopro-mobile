import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class TinyBitController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> adapterStateStateSubscription;
  late StreamSubscription<BluetoothConnectionState>
      deviceConnectionStateSubscription;
  var isScanning = true.obs;
  late BluetoothDevice device;
  late StreamSubscription<ScanResult> scanSubscription;
  var ultraSonic = "0".obs;
  var temperature = "0".obs;
  final List<String> whiteKeys = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  final List<String> blackKeys = ['C#', 'D#', '', 'F#', 'G#', 'A#'];

  var trackingMode = false.obs;
  var obstacleAvoidanceMode = false.obs;
  var followingMode = false.obs;

  List<Widget> listTab = [
    const Tab(
      text: 'Music',
      icon: Icon(Icons.music_note_rounded),
    ),
    const Tab(
      text: 'Car Lights',
      icon: Icon(Icons.lightbulb),
    ),
    const Tab(
      text: 'RGB Lights',
      icon: Icon(Icons.color_lens_rounded),
    ),
    const Tab(
      text: 'Mode',
      icon: Icon(Icons.settings),
    ),
  ];

  String UART_SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";

  String UART_TX_CHARACTERISTIC_UUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";

  String UART_RX_CHARACTERISTIC_UUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

  scan() async {
    try {
      int divisor = Platform.isAndroid ? 8 : 1;
      await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 10),
          continuousUpdates: false,
          continuousDivisor: divisor);
    } catch (e) {
      print(e);
    }
  }

  sendData(String data) async {
    try {
      for (var service in device.servicesList) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid.toString() == UART_RX_CHARACTERISTIC_UUID) {
            await characteristic.write(utf8.encode(data));
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);
    super.onInit();
    adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((s) {
      adapterState = s;
      if (s == BluetoothAdapterState.on) {
        scan();
        FlutterBluePlus.scanResults.listen((results) async {
          for (var r in results) {
            if (r.device.advName.contains("BBC")) {
              await r.device.connect();
              await r.device.discoverServices();
              deviceConnectionStateSubscription =
                  r.device.connectionState.listen((event) async {
                if (event == BluetoothConnectionState.disconnected) {
                  Get.back();
                }
              });
              device = r.device;
              sendData("0#");
              for (var service in device.servicesList) {
                for (BluetoothCharacteristic characteristic
                    in service.characteristics) {
                  if (characteristic.uuid.toString() ==
                      UART_TX_CHARACTERISTIC_UUID) {
                    await characteristic.setNotifyValue(true);
                    characteristic.onValueReceived.listen((value) async {
                      value.remove(36);
                      value.remove(35);
                      String valResponse = String.fromCharCodes(value);
                      valResponse = valResponse.replaceAll("CSB", "");
                      ultraSonic.value = valResponse.split(",")[0];
                      temperature.value = valResponse.split(",")[1];
                    });
                  }
                }
              }

              isScanning.value = false;
              FlutterBluePlus.stopScan();
            }
          }
        }, onError: (e) {
          print(e);
        });
      } else {
        Get.back();
        Get.snackbar('Error', 'Bluetooth is off please turn it on',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }

  @override
  void onClose() async {
    await deviceConnectionStateSubscription.cancel();
    await adapterStateStateSubscription.cancel();
    await device.disconnect();

    super.onClose();
  }
}
