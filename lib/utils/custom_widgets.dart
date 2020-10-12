import 'package:flutter/material.dart';

import 'custom_colors.dart';
import 'custom_style.dart';

class CustomWidgets{

	static Widget buttonWithBorder(Function onTap, String text) {
		return InkWell(
			onTap: (){
				onTap();
			},
			focusColor: Colors.transparent,
			hoverColor: Colors.transparent,
			highlightColor: Colors.transparent,
			splashColor: Colors.transparent,
			child: Padding(
			  padding: const EdgeInsets.symmetric(horizontal: 20),
			  child: Container(
			  	height: 45,
			  	decoration: BoxDecoration(
			  		borderRadius: BorderRadius.circular(40),
			  		border: Border.all(color: CustomColors.blue, width: 2),
			  	),
			  	child: Center(
			  		child: Text(
			  			text,
			  			style: CustomStyle.connectionButtonStyle,
			  		),
			  	),
			  ),
			),
		);
	}

	static Widget textWithLoadingIndicator(String text) {
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 10),
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: <Widget>[
					_textWidget(text),
					SizedBox(
						height: 30,
					),
					Container(
						height: 35,
						child: CircularProgressIndicator(),
					)
				],
			),
		);
	}

	static Widget textWithoutLoadingIndicator(String text) {
		return _textWidget(text);
	}

	static Widget bluetoothIsOff() {
		return Center(
			child: CustomWidgets.textWithoutLoadingIndicator("Bluetooth is off!"),
		);
	}

	static _textWidget(String text) {
		return Text(
			text,
			textAlign: TextAlign.center,
			style: CustomStyle.textIndicator,
		);
	}


}