import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

import '../blue_serial.dart';
import 'session.dart';

const int PERIPHERAL_UNPLUG_CHECK_INTERVAL = 100;

class SerialportSession extends Session {
  WebSocket? socket;
  String userDataPath;
  String toolsPath;
  dynamic peripheralParams;
  dynamic services;
  Map<String, dynamic> reportedPeripherals = {};
  Timer? connectStateDetectorTimer;
  Timer? peripheralsScanorTimer;
  bool isRead = false;
  bool isInDisconnect = false;
  dynamic tool;
  BlueSerialService bluetoothService = Get.find<BlueSerialService>();
  StreamSubscription<BluetoothDiscoveryResult>? deviceStreamSubscription;

  SerialportSession(this.socket, this.userDataPath, this.toolsPath)
      : super(socket);

  @override
  void dispose() {
    disconnect();
    super.dispose();
    socket = null;
    peripheralParams = null;
    services = null;
    reportedPeripherals = {};
    connectStateDetectorTimer?.cancel();
    connectStateDetectorTimer = null;
    peripheralsScanorTimer?.cancel();
    peripheralsScanorTimer = null;
  }

  @override
  Future<void> didReceiveCall(
      String method, dynamic params, Function sendResult) async {
    print('didReceiveCall: $method ${jsonEncode(params)}');
    switch (method) {
      case "discover":
        discover(params);
        sendResult(null, null);
        break;
      case "connect":
        await connect(params);
        sendResult(null, null);
        break;
      case "disconnect":
        await disconnect();
        sendResult(null, null);
        break;
      case "updateBaudrate":
        sendResult(await updateBaudrate(params), null);
        break;
      case "write":
        sendResult(await write(params), null);
        break;
      case "read":
        await read(params);
        sendResult(null, null);
        break;
      case "upload":
        sendResult(await upload(params), null);
        break;
      case "uploadFirmware":
        sendResult(await uploadFirmware(params), null);
        break;
      case "abortUpload":
        sendResult(await abortUpload(), null);
        break;
      case "getServices":
        sendResult(
            (services ?? []).map((service) => service['uuid']).toList(), null);
        break;
      case "pingMe":
        sendResult("willPing", null);
        sendRemoteRequest("ping", null, (result) {
          print('Got result from ping: $result');
        });
        break;
      default:
        throw Exception('Method not found');
    }
  }

  void discover(dynamic params) async {
    if (services != null) {
      throw Exception("cannot discover when connected");
    }
    await bluetoothService.init();

    if (bluetoothService.bluetoothState == BluetoothState.STATE_OFF ||
        bluetoothService.bluetoothState == BluetoothState.STATE_TURNING_OFF ||
        bluetoothService.bluetoothState == BluetoothState.UNKNOWN) {
      await FlutterBluetoothSerial.instance.requestEnable().then((value) {
        if (value == true) {
          startDiscovery();
        } else {
          Get.back();
          Get.snackbar("Bluetooth", "Bluetooth is not enabled",
              snackPosition: SnackPosition.BOTTOM);
        }
      });
    } else {
      startDiscovery();
    }
  }

  startDiscovery() {
    final device = [];
    device.clear();
    deviceStreamSubscription = bluetoothService.startDiscovery((result) {
      device.add({
        "peripheralId": result?.device.address,
        "name": result?.device.name ?? "Unknown",
      });
    });
    deviceStreamSubscription?.onDone(() {
      for (var element in device) {
        sendRemoteRequest("didDiscoverPeripheral", element, (result) {
          print('Got result from didDiscoverPeripheral: $result');
        });
      }
    });
  }

  Future<void> connect(dynamic params,
      [bool isConnectAfterUpload = false]) async {}

  void onMessageCallback(dynamic rev) {
    final params = {
      'encoding': 'base64',
      'message': base64.encode(rev),
    };
    if (isRead) {
      sendRemoteRequest("onMessage", params, (result) {
        print('Got result from onMessage: $result');
      });
    }
  }

  Future<void> updateBaudrate(dynamic params) async {}

  Future<void> write(dynamic params) async {}

  Future<void> read(dynamic params) async {
    isRead = true;
  }

  Future<void> disconnect() async {
    isInDisconnect = true;
  }

  Future<void> upload(dynamic params) async {}

  Future<void> uploadFirmware(dynamic params) async {}

  Future<void> abortUpload() async {
    if (tool != null) {
      tool.abortUpload();
    }
  }

  void sendstd(String message) {}
}
