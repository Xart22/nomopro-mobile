import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

import '../blue_serial.dart';

BlueSerialService bluetoothService = Get.find<BlueSerialService>();
StreamSubscription<BluetoothDiscoveryResult>? deviceStreamSubscription;
Map<int, dynamic>? _completionHandlers = {};
int _nextId = 0;
WebSocket? _socket;
var peripheralsScanorTimer;
bool isConnected = false;
bool isDiscovering = false;
bool isRead = false;
bool isInDisconnect = false;
bool peripheralUnplugged = false;
dynamic port;

Future<void> startServer() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 20111);
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    if (request.uri.path == '/openblock/serialport') {
      // Upgrade an HttpRequest to a WebSocket connection
      _socket = await WebSocketTransformer.upgrade(request);

      // Listen for incoming data
      _socket?.listen((dynamic data) {
        final request = jsonDecode(data);
        final method = request['method'];
        final params = request['params'];
        final requestId = request['id'];
        if (method != null) {
          didReceiveCall(method, params, (error, result) {
            final response = {
              'jsonrpc': '2.0',
              'id': requestId,
            };
            if (error != null) {
              response['error'] = error;
            } else {
              response['result'] = result;
            }
            _socket?.add(jsonEncode(response));
          });
        }
      });
    } else {
      request.response.statusCode = HttpStatus.forbidden;
      request.response.close();
    }
  }
}

Future<void> didReceiveCall(
    String method, dynamic params, Function sendResult) async {
  print('didReceiveCall: $method ${jsonEncode(params)}');
  switch (method) {
    case "discover":
      discover();
      break;
    case "connect":
      connect(jsonEncode(params));
      break;
    case "read":
      break;
    case "write":
      break;
    default:
      throw Exception('Method not found');
  }
}

void discover() async {
  await bluetoothService.init();

  if (bluetoothService.bluetoothState == BluetoothState.STATE_OFF ||
      bluetoothService.bluetoothState == BluetoothState.STATE_TURNING_OFF ||
      bluetoothService.bluetoothState == BluetoothState.UNKNOWN) {
    await FlutterBluetoothSerial.instance.requestEnable().then((value) {
      if (value == true) {
        startDiscovery();
      } else {
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
  if (!isDiscovering) {
    isDiscovering = true;
    peripheralsScanorTimer?.cancel();
    deviceStreamSubscription = bluetoothService.startDiscovery((result) {
      device.add({
        "peripheralId": result?.device.address,
        "name": result?.device.name ?? "Unknown",
      });
    });
    deviceStreamSubscription?.onDone(() {
      isDiscovering = false;
      if (device.isNotEmpty) {
        peripheralsScanorTimer =
            Timer.periodic(const Duration(seconds: 1), (timer) {
          sendRemoteRequest("didDiscoverPeripheral", device, null);
        });
      }
    });
  }
}

connect(params) async {
  try {
    peripheralsScanorTimer?.cancel();
    params = json.decode(params);
    await bluetoothService.connect(params["peripheralId"], (p0) => port = p0);
  } catch (e) {
    print(e.toString());
    sendRemoteRequest("connectError", e.toString(), null);
    _socket?.close();
  }
}

void sendRemoteRequest(
  String? method,
  Object? params,
  Function? completion,
) {
  final request = {
    'jsonrpc': '2.0',
    'method': method,
  };

  if (params != null) {
    request['params'] = jsonEncode(params);
  }
  if (completion != null) {
    final requestId = getNextId();
    request['id'] = requestId.toString();
    _completionHandlers?[requestId] = completion;
  }

  try {
    if (_socket != null) {
      _socket!.add(jsonEncode(request));
    }
  } catch (err) {
    print('Error serializing or sending request: $err');
    print('Request was: $request');
  }
}

int getNextId() {
  return _nextId++;
}
