import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:maquetteig2i/repository/bluetooth_repository.dart';
import 'bloc.dart';
import 'dart:developer' as dev;

class BluetoothBloc extends Bloc<BluetoothEvent, MyBluetoothState> {
  final BluetoothRepository bluetoothRepository;
  FlutterBlue flutterBlue;
  ValueNotifier valueNotifierInfo;

  BluetoothBloc(this.bluetoothRepository) {
    flutterBlue = FlutterBlue.instance;
  }

  @override
  MyBluetoothState get initialState => InitialBluetoothState();

  @override
  Stream<MyBluetoothState> mapEventToState(
    BluetoothEvent event,
  ) async* {

    dev.log("new event : $event",name: "Bluetooth bloc");

    //find device
    if (event is FindEsp32Device) {

      yield SearchingForEsp32DeviceState();
      FlutterBlue.instance.startScan(
          timeout: Duration(seconds: BluetoothRepository.SCAN_TIMEOUT));
      bool deviceFound =
          await bluetoothRepository.findEsp32Device(flutterBlue, event.name);
      if (!deviceFound) {
        yield Esp32DeviceNotFoundState();
        return;
      }
      yield Esp32DeviceFoundState();
      bool connected = await bluetoothRepository.connectToDevice();

      if (!connected) {
        yield FailedToConnectState();
        return;
      }

      bool hasTheRightCharacteristics = await bluetoothRepository.hasTheRightCharacteristics();
      if (!hasTheRightCharacteristics) {
        yield FailedToConnectState();
        return;
      }

      yield SucceedToConnectState();

      return;
    }

    if (event is SendEvent){
      bluetoothRepository.envoiLaTrameMTU([event.value]);
    }

    if (event is SendTrame){
      bluetoothRepository.envoiLaTrameMTU(event.values);
    }

    if (event is SubscribeToInfo){
      bluetoothRepository.subscribeToInfoCharacteristic(valueNotifierInfo);
    }
    
  }

  void dispose() {
    dev.log("dispose bluetooth bloc", name: "Bluetooth bloc");
    flutterBlue.stopScan();
    bluetoothRepository?.dispose();
  }

  void setValueNotifierInfo(ValueNotifier v){
    valueNotifierInfo = v;
  }
}