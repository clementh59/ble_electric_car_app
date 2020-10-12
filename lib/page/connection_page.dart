import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maquetteig2i/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:maquetteig2i/bloc/bluetooth/bluetooth_event.dart';
import 'package:maquetteig2i/database.dart';
import 'package:maquetteig2i/utils/custom_colors.dart';
import 'package:maquetteig2i/utils/custom_style.dart';
import 'package:maquetteig2i/widgets/voiture_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'dashboard_page.dart';

class ConnectionPage extends StatefulWidget {

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
          child: PageView(
            children: _buildVoitures(),
          ),
        ),
      ),
    );
  }

  Widget _buttonConnect(String modele, String marque, String asset) {
    return InkWell(
      onTap: () {
        BlocProvider.of<BluetoothBloc>(context).add((FindEsp32Device(modele)));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashBoardPage(modele,marque,asset)),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Icon(
            Icons.lock_outline,
            size: 37,
            color: CustomColors.white,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff10a6fb),
              border: Border.all(color: Color(0xff10a6fb), width: 3),
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
      ),
    );
  }

  List<Widget> _buildVoitures(){
    List<Widget> list = [];

    for(int i=0; i<database.voitures.length; i++){
      list.add(Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(),
          VoitureWidget(marque: database.voitures[i]["marque"],asset: database.voitures[i]["asset"],modele : database.voitures[i]["modele"],puissance: database.voitures[i]["puissance"],offset_text: database.voitures[i]["offset"],),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buttonConnect(database.voitures[i]["modele"], database.voitures[i]["marque"],database.voitures[i]["asset"]),
              SizedBox(
                height: 5,
              ),
              Shimmer.fromColors(
                baseColor: CustomColors.grey,
                highlightColor: Colors.white,
                child: Text(
                  'Tap to open the car',
                  textAlign: TextAlign.center,
                  style: CustomStyle.tap_to_open_the_car,
                ),
              ),
            ],
          ),
          SizedBox(),
        ],
      ));
    }

    return list;
  }

}
