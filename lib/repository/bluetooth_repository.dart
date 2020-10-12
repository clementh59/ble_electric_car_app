import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothRepository {
  static const int MTU_SIZE = 254;
  static const int SCAN_TIMEOUT = 10; //time out de 10s pour le scan
  static const String uuidOfMainCommunication = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  static const String uuidOfInfoCommunication = "beb5483e-36e1-4688-b7f5-ea07361b26a7";

  BluetoothDevice esp32Device;
  BluetoothCharacteristic mainBluetoothCharacteristic;
  BluetoothCharacteristic infoBluetoothCharacteristic;
  StreamSubscription streamSubscriptionInfoListening;
  String targetName;

  Future<Null> envoiLaTrameMTU(List<int> trame) async {
    print(trame);
    await mainBluetoothCharacteristic.write(trame);
  }

  Future<bool> findEsp32Device(FlutterBlue flutterBlue, String name) async {

    targetName = name;

    List<BluetoothDevice> connectedDevices = await flutterBlue.connectedDevices;

    for (BluetoothDevice device in connectedDevices) {
      if (isEsp32Device(device)) {
        flutterBlue.stopScan();
        return true;
      }
    }

    BluetoothDevice esp32Device;

    bool isScanning = true;
    bool isCheckingResult = false;

    while (isScanning) {
      if (!isCheckingResult) {
        isCheckingResult = true;
        flutterBlue.scanResults.firstWhere((list) {
          print(list);
          for (ScanResult scanResult in list) {
            if (isEsp32Device(scanResult.device)) {
              esp32Device = scanResult.device;
            }
          }
          isCheckingResult = false;
          return true;
        });

        if (esp32Device != null) {
          flutterBlue.stopScan();
          return true;
        }
      }

      await new Future.delayed(const Duration(seconds: 1));

      isScanning = await flutterBlue.isScanning.first;

      if (isScanning == null) isScanning = false;
    }

    return false;
  }

  bool isEsp32Device(BluetoothDevice bluetoothDevice) {
    if (bluetoothDevice.name == targetName) {
      dev.log('Target device found', name: "findDevice");
      esp32Device = bluetoothDevice;
      return true;
    }
    return false;
  }

  Future<bool> connectToDevice() async {
    try {
      await esp32Device.connect();
      return true;
    } catch (id) {
      print("error : " + id.toString());
      if (id.toString() ==
          "PlatformException(already_connected, connection with device already exists, null)") {
        return true; //je suis déjà connecté
      }
      return false;
    }
  }

  Future<bool> hasTheRightCharacteristics() async {
    List<BluetoothService> services = await esp32Device.discoverServices();

    for (BluetoothService service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        print(c.uuid);
        if (c.uuid.toString() == uuidOfMainCommunication) {
          mainBluetoothCharacteristic = c;
        }
        else if (c.uuid.toString() == uuidOfInfoCommunication){
          infoBluetoothCharacteristic = c;
        }
      }
    }

    if (mainBluetoothCharacteristic != null && infoBluetoothCharacteristic != null) {
      return true;
    }
    return false;
  }

  Future<int> subscribeToInfoCharacteristic(ValueNotifier valueNotifierActualTick) async {
    await infoBluetoothCharacteristic.setNotifyValue(true);
    print("Subscribe to info characteristics");
    streamSubscriptionInfoListening?.cancel();
    streamSubscriptionInfoListening =
      infoBluetoothCharacteristic.value.listen((event) {

        print(event);

        if (event.length == 4) {
          int value = event[0] +
            event[1] * 256;

          valueNotifierActualTick.value = value;
          valueNotifierActualTick.notifyListeners();
        }

      });

    return 0;
  }

  void dispose() {
    mainBluetoothCharacteristic = null;
    infoBluetoothCharacteristic = null;
  }

}
