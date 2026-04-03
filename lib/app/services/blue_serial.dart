import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/message_model.dart';

class BlueSerialService extends GetxService {
  final blueSerial = BluetoothClassic();
  bool bluetoothEnabled = false;
  bool isConnected = false;
  final ScrollController listScrollController = ScrollController();
  var messages = <Message>[].obs;
  var messageBuffer = ''.obs;
  var chat = <Row>[].obs;
  var address = "".obs;
  var name = "".obs;

  Timer? discoverableTimeoutTimer;
  int discoverableTimeoutSecondsLeft = 0;
  StreamSubscription? _dataSubscription;
  StreamSubscription? _discoverySubscription;
  List<Device> discoveredDevices = [];

  Future<List<Device>> startDiscovery() async {
    try {
      discoveredDevices.clear();

      // First get paired devices
      List<Device> pairedDevices = await blueSerial.getPairedDevices();
      discoveredDevices.addAll(pairedDevices);

      // Then start scanning for new devices
      _discoverySubscription = blueSerial.onDeviceDiscovered().listen((device) {
        if (!discoveredDevices.any((d) => d.address == device.address)) {
          discoveredDevices.add(device);
        }
      });

      await blueSerial.startScan();

      return discoveredDevices;
    } catch (e) {
      print(e);
      return discoveredDevices;
    }
  }

  Future<void> stopDiscovery() async {
    try {
      await _discoverySubscription?.cancel();
      await blueSerial.stopScan();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> connect(String address, Function(Uint8List)? chatBuilder) async {
    try {
      // Use SPP UUID for serial communication
      String sppUUID = "00001101-0000-1000-8000-00805F9B34FB";
      await blueSerial.connect(address, sppUUID);

      if (chatBuilder != null) {
        _dataSubscription = blueSerial.onDeviceDataReceived().listen((data) {
          chatBuilder(data);
        });
      }
      isConnected = true;
      return true;
    } catch (exception) {
      print(exception);
      return false;
    }
  }

  disconnect() async {
    await _dataSubscription?.cancel();
    await blueSerial.disconnect();
    isConnected = false;
  }

  void write(Uint8List data) async {
    try {
      await blueSerial.write(String.fromCharCodes(data));
    } catch (e) {
      print(e);
    }
  }

  Future<BlueSerialService> init() async {
    await blueSerial.initPermissions();

    bluetoothEnabled = true; // Assume enabled after permission init

    return this;
  }
}
