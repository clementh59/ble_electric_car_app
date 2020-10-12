import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class BluetoothEvent extends Equatable {
  BluetoothEvent();
}

class FindEsp32Device extends BluetoothEvent{

  final String name;

  @override
  List<Object> get props => [name];

  FindEsp32Device(this.name);
}

class SendEvent extends BluetoothEvent{

  final int value;

  SendEvent(this.value);

  @override
  List<Object> get props => [value];
}

class SendTrame extends BluetoothEvent{

  final List<int> values;

  SendTrame(this.values);

  @override
  List<Object> get props => [values];
}



class SubscribeToInfo extends BluetoothEvent{

  SubscribeToInfo();

  @override
  List<Object> get props => [];
}

