import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maquetteig2i/page/connection_page.dart';
import 'package:maquetteig2i/repository/bluetooth_repository.dart';

import 'bloc/bluetooth/bluetooth_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BluetoothBloc>(create: (BuildContext context) {
          return BluetoothBloc(BluetoothRepository());
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: ConnectionPage(),
      ),
    );
  }
}