import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

class UsbSerialService extends GetxService {
  static const _channel =
      MethodChannel('com.nomokit.sona.nomokit.USB_PERMISSION');
  UsbPort? port;
  var status = "Idle".obs;
  var ports = <Widget>[].obs;
  var serialData = <Widget>[].obs;

  StreamSubscription<String>? subscription;
  Transaction<String>? transaction;
  UsbDevice? device;

  Future<bool> requestPermission() async {
    return await _channel.invokeMethod('askUsbPermission');
  }

  Future<bool> connectTo(UsbDevice? device) async {
    serialData.clear();

    if (subscription != null) {
      subscription!.cancel();
      subscription = null;
    }

    if (transaction != null) {
      transaction!.dispose();
      transaction = null;
    }

    if (port != null) {
      port!.close();
      port = null;
    }

    if (device == null) {
      device = null;

      status.value = "Disconnected";

      return true;
    }

    port = await device.create();
    if (await (port!.open()) != true) {
      status.value = "Failed to open port";
      return false;
    }
    device = device;

    await port!.setDTR(true);
    await port!.setRTS(true);
    await port!.setPortParameters(
        9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    transaction = Transaction.stringTerminated(
        port!.inputStream as Stream<Uint8List>, Uint8List.fromList([13, 10]));

    subscription = transaction!.stream.listen((String line) {
      serialData.add(Text(line));
      if (serialData.length > 20) {
        serialData.removeAt(0);
      }
    });

    status.value = "Connected";

    return true;
  }

  getPorts() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (!devices.contains(device)) {
      connectTo(null);
    }
    ports.clear();

    for (var item in devices) {
      ports.add(ListTile(
          leading: const Icon(Icons.usb),
          title: Text(item.productName ?? ""),
          subtitle: Text(item.manufacturerName ?? ""),
          trailing: ElevatedButton(
            child: Text(item == device ? "Disconnect" : "Connect"),
            onPressed: () {
              device = item == device ? null : item;
              connectTo(device).then((res) {
                getPorts();
              });
            },
          )));
    }
  }

  Future<UsbSerialService> init() async {
    await requestPermission();
    return this;
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onClose() {
    super.onClose();
    connectTo(null);
  }
}
