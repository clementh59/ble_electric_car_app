import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:maquetteig2i/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:maquetteig2i/bloc/bluetooth/bluetooth_event.dart';
import 'package:maquetteig2i/bloc/bluetooth/bluetooth_state.dart';
import 'package:maquetteig2i/utils/custom_colors.dart';
import 'package:maquetteig2i/utils/custom_style.dart';
import 'package:maquetteig2i/utils/custom_widgets.dart';

class DashBoardPage extends StatefulWidget {

  final String marque;
  final String modele;
  final String asset;

  DashBoardPage(this.modele, this.marque, this.asset);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<int> valueNotifierValueReceived = new ValueNotifier(0);
  int infoValue = 0;

  //valeur envoyee
  bool _on_off_1_val = false;
  bool _on_off_2_val = false;
  int _menu1OptionChosen = 0;
  int _menu2OptionChosen = 0;
  int consigneVitesse = 0;
  int consigneCourant = 0;

  //valeur recues
  int vitesseValue = 0;
  int courantValue = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<BluetoothBloc>(context)
        .setValueNotifierInfo(valueNotifierValueReceived);
    BlocProvider.of<BluetoothBloc>(context).add(SubscribeToInfo());
    valueNotifierValueReceived.addListener(() {
      setState(() {
        vitesseValue = valueNotifierValueReceived.value % 256;
        courantValue = ((valueNotifierValueReceived.value - vitesseValue)/256).floor();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.backgroundColor,
      body: SafeArea(
        child: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          builder: (c, snapshot) {
            if (snapshot.data == BluetoothState.on) {
              return BlocBuilder<BluetoothBloc, MyBluetoothState>(
                builder: (BuildContext context, MyBluetoothState state) {
                  if (state is SucceedToConnectState) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            CustomColors.backgroundColorTop,
                            CustomColors.backgroundColorBottom,
                          ])),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 7,
                              ),
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        Icons.keyboard_arrow_left,
                                        color: CustomColors.white,
                                        size: 38,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.marque,
                                          style: CustomStyle.marque_style_home
                                            .copyWith(fontSize: 14),
                                        ),
                                        _modeleText(widget.modele, 14),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(widget.asset)),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Control",
                                  style: CustomStyle.title_dashboard,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _neomorphicButtonWithText(_on_off_1_val ? "ON" : "OFF",
                                      () {
                                      setState(() {
                                        _on_off_1_val = !_on_off_1_val;
                                      });
                                      envoiLaTrame();
                                    },"Switch 1"),
                                  _neomorphicButtonWithText(_on_off_2_val ? "ON" : "OFF",
                                      () {
                                      setState(() {
                                        _on_off_2_val = !_on_off_2_val;
                                      });
                                      envoiLaTrame();
                                    },"Switch 2"),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  menu1(),
                                  menu2(),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 22),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Reference 1",
                                  style: CustomStyle.title_dashboard.copyWith(
                                    fontSize: 12, fontWeight: CustomStyle.REGULAR),
                                ),
                              ),
                              _speedSlider(),
                              Container(
                                padding: EdgeInsets.only(left: 22),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Reference 2",
                                  style: CustomStyle.title_dashboard.copyWith(
                                    fontSize: 12, fontWeight: CustomStyle.REGULAR),
                                ),
                              ),
                              _currentSlider(),
                              Container(
                                padding: EdgeInsets.only(left: 22),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Mesure 1",
                                  style: CustomStyle.title_dashboard.copyWith(
                                    fontSize: 12, fontWeight: CustomStyle.REGULAR),
                                ),
                              ),
                              _speedSliderReceive(),
                              Container(
                                padding: EdgeInsets.only(left: 22),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Mesure 2",
                                  style: CustomStyle.title_dashboard.copyWith(
                                    fontSize: 12, fontWeight: CustomStyle.REGULAR),
                                ),
                              ),
                              _currentSliderReceive(),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is SearchingForEsp32DeviceState) {
                    return Center(
                      child: CustomWidgets.textWithLoadingIndicator(
                          "Recherche de l'esp32"),
                    );
                  }
                  if (state is Esp32DeviceNotFoundState) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomWidgets.textWithoutLoadingIndicator(
                              "L'esp32 n'a pas été trouvé"),
                          SizedBox(
                            height: 20,
                          ),
                          CustomWidgets.buttonWithBorder(() {
                            BlocProvider.of<BluetoothBloc>(context)
                                .add((FindEsp32Device(widget.modele)));
                          }, "Réessayer")
                        ],
                      ),
                    );
                  }
                  if (state is FailedToConnectState) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomWidgets.textWithoutLoadingIndicator(
                              "Connection à l'esp32 impossible"),
                          SizedBox(
                            height: 20,
                          ),
                          CustomWidgets.buttonWithBorder(() {
                            BlocProvider.of<BluetoothBloc>(context)
                                .add((FindEsp32Device(widget.modele)));
                          }, "Réessayer")
                        ],
                      ),
                    );
                  }
                  if (state is Esp32DeviceFoundState) {
                    return Center(
                      child: CustomWidgets.textWithLoadingIndicator(
                          "Esp32 trouvé, connection en cours..."),
                    );
                  }

                  return SizedBox();
                },
              );
            }
            return Center(child: CustomWidgets.bluetoothIsOff());
          },
        ),
      ),
    );
  }

  Widget _speedSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                consigneVitesse.toString(),
                style: CustomStyle.marque_style_home.copyWith(fontSize: 10),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "127",
                style: CustomStyle.marque_style_home.copyWith(fontSize: 10),
              ),
            ),
          ],
        ),
        Container(
          transform: Matrix4.translationValues(0.0, -16.0, 0.0),
          child: SliderTheme(
            data: SliderThemeData(
              thumbColor: CustomColors.blue,
              activeTrackColor: CustomColors.blue,
              inactiveTrackColor: CustomColors.greyLighter,
              trackHeight: 3.0,
              showValueIndicator: ShowValueIndicator.always,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
            child: Slider(
              onChangeEnd: (value) {
                updateSpeed();
              },
              divisions: 127,
              //pour eviter erreur
              value: consigneVitesse.toDouble(),
              onChanged: (newTime) {
                setState(() {
                  consigneVitesse = newTime.floor();
                });
              },
              min: 0,
              max: 127,
              label: consigneVitesse.toString(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _speedSliderReceive() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                vitesseValue.toString(),
                style: CustomStyle.marque_style_home.copyWith(fontSize: 10),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "127",
                style: CustomStyle.marque_style_home.copyWith(fontSize: 10),
              ),
            ),
          ],
        ),
        Container(
          transform: Matrix4.translationValues(0.0, -16.0, 0.0),
          child: SliderTheme(
            data: SliderThemeData(
              thumbColor: CustomColors.blue,
              activeTrackColor: CustomColors.blue,
              inactiveTrackColor: CustomColors.greyLighter,
              trackHeight: 3.0,
              showValueIndicator: ShowValueIndicator.never,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2)),
            child: Slider(
              divisions: 127,
              //pour eviter erreur
              value: vitesseValue.toDouble(),
              onChanged: (newTime) {},
              min: 0,
              max: 127,
              label: vitesseValue.toString(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _currentSliderReceive() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                courantValue.toString(),
                style: CustomStyle.marque_style_home.copyWith(fontSize: 10),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "127",
                style: CustomStyle.marque_style_home.copyWith(fontSize: 10),
              ),
            ),
          ],
        ),
        Container(
          transform: Matrix4.translationValues(0.0, -16.0, 0.0),
          child: SliderTheme(
            data: SliderThemeData(
              thumbColor: CustomColors.blue,
              activeTrackColor: CustomColors.blue,
              inactiveTrackColor: CustomColors.greyLighter,
              trackHeight: 3.0,
              showValueIndicator: ShowValueIndicator.never,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2)),
            child: Slider(
              divisions: 127,
              //pour eviter erreur
              value: courantValue.toDouble(),
              onChanged: (newTime) {},
              min: 0,
              max: 127,
              label: courantValue.toString(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _currentSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                consigneCourant.toString(),
                style: CustomStyle.marque_style_home.copyWith(fontSize: 10),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "127",
                style: CustomStyle.marque_style_home.copyWith(fontSize: 10),
              ),
            ),
          ],
        ),
        Container(
          transform: Matrix4.translationValues(0.0, -16.0, 0.0),
          child: SliderTheme(
            data: SliderThemeData(
              thumbColor: CustomColors.blue,
              activeTrackColor: CustomColors.blue,
              inactiveTrackColor: CustomColors.greyLighter,
              trackHeight: 3.0,
              showValueIndicator: ShowValueIndicator.always,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
            child: Slider(
              onChangeEnd: (value) {
                updateCurrent();
              },
              divisions: 127,
              //pour eviter erreur
              value: consigneCourant.toDouble(),
              onChanged: (newValue) {
                setState(() {
                  consigneCourant = newValue.floor();
                });
              },
              min: 0,
              max: 127,
              label: consigneCourant.toString(),
            ),
          ),
        ),
      ],
    );
  }

  List<int> construitLaTrame() {
    List<int> trame = [];

    int firstByte = 0;

    if (_on_off_1_val) firstByte += 128;

    if (_on_off_2_val) firstByte += 64;

    if (_menu1OptionChosen == 1) {
      firstByte += 16;
    } else if (_menu1OptionChosen == 2) {
      firstByte += 32;
    } else if (_menu1OptionChosen == 3) {
      firstByte += 48;
    }

    trame.add(firstByte);
    trame.add(consigneVitesse);
    trame.add(consigneCourant);
    trame.add(_menu2OptionChosen);
    trame.add(0);
    trame.add(0);
    trame.add(0);
    trame.add(0);

    return trame;
  }

  Widget _neomorphicButtonWithText(String text, Function onTap, String name) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Column(
          children: [
            Text(
              name,
              style: CustomStyle.title_dashboard
                .copyWith(fontSize: 12, fontWeight: CustomStyle.REGULAR),
            ),
            SizedBox(height: 5,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Text(
                text,
                style: CustomStyle.modele_style_home.copyWith(fontSize: 14),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xff10a6fb),
                border: Border.all(color: Color(0xff10a6fb), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff09090b),
                    offset: Offset(4.0, 4.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0),
                  BoxShadow(
                    color: Color(0xff252d31),
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff0260a5),
                    Color(0xff1085cd),
                    Color(0xff1195e3),
                    Color(0xff10a6fb),
                  ],
                  stops: [
                    0.1,
                    0.3,
                    0.8,
                    1
                  ])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeleText(String modele, double fontSize) {
    return ClipRect(
      child: new Stack(
        children: [
          new Positioned(
            top: 1.0,
            left: 1.0,
            child: new Text(
              modele,
              style: CustomStyle.modele_style_home.copyWith(
                color: Colors.white.withOpacity(0.5), fontSize: fontSize),
            ),
          ),
          new BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: new Text(modele,
              style:
              CustomStyle.modele_style_home.copyWith(fontSize: fontSize)),
          ),
        ],
      ),
    );
  }

  void envoiLaTrame(){
    List<int> trame = construitLaTrame();
    BlocProvider.of<BluetoothBloc>(context).add((SendTrame(trame)));
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text("Trame envoyée!")));
  }

  void updateSpeed() {
    envoiLaTrame();
  }

  void updateCurrent() {
    envoiLaTrame();
  }

  Widget menu1(){
    return DropdownButton(
      value: _menu1OptionChosen,
      items: [
        DropdownMenuItem(
          child: Text(
            "Mode 1",
            style: CustomStyle.greyTextIndicator,
          ),
          value: 0,
        ),
        DropdownMenuItem(
          child: Text(
            "Mode 2",
            style: CustomStyle.greyTextIndicator,
          ),
          value: 1,
        ),
        DropdownMenuItem(
          child: Text(
            "Mode 3",
            style: CustomStyle.greyTextIndicator,
          ),
          value: 2,
        ),
        DropdownMenuItem(
          child: Text(
            "Mode 4",
            style: CustomStyle.greyTextIndicator,
          ),
          value: 3,
        ),
      ],
      onChanged: (value) {
        setState(() {
          _menu1OptionChosen = value;
        });
      },
    );
  }

  Widget menu2(){
    return DropdownButton(
      value: _menu2OptionChosen,
      items: [
        DropdownMenuItem(
          child: Text(
            "All",
            style: CustomStyle.greyTextIndicator,
          ),
          value: 0,
        ),
        _buildANode(1),
        _buildANode(2),
        _buildANode(3),
        _buildANode(4),
        _buildANode(5),
        _buildANode(6),
        _buildANode(7),
        _buildANode(8),
        _buildANode(9),
        _buildANode(10),
        _buildANode(11),
        _buildANode(12),
        _buildANode(13),
        _buildANode(14),
        _buildANode(15),
        _buildANode(16),
      ],
      onChanged: (value) {
        setState(() {
          _menu2OptionChosen = value;
        });
      },
    );
  }

  DropdownMenuItem _buildANode(int number){
    return DropdownMenuItem(
      child: Text(
        "Node " + number.toString(),
        style: CustomStyle.greyTextIndicator,
      ),
      value: number,
    );
  }

}
