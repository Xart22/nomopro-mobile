import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BlueSerialService extends GetxService {
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;

  String? address;
  String? name;

  Timer? discoverableTimeoutTimer;
  int discoverableTimeoutSecondsLeft = 0;

  Future<BlueSerialService> init() async {
    await Permission.bluetoothConnect.request();
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState = state;
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((add) {
        address = add!;
      });
    });

    FlutterBluetoothSerial.instance.name.then((nm) {
      name = nm!;
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState = state;

      // Discoverable mode is disabled when Bluetooth gets disabled
      discoverableTimeoutTimer = null;
      discoverableTimeoutSecondsLeft = 0;
    });

    return this;
  }
}
