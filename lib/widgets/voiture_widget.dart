import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:maquetteig2i/utils/custom_style.dart';

class VoitureWidget extends StatelessWidget {

	final String marque;
	final String modele;
	final String asset;
	final int puissance;
	final double offset_text;

	VoitureWidget(
		{this.marque, this.modele, this.asset, this.puissance, this.offset_text});

  @override
  Widget build(BuildContext context) {
    return Column(
			children: [
				Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Text(
							marque,
							style: CustomStyle.marque_style_home,
						),
						_modeleText(modele),
					],
				),
				Center(
					child: Stack(
						children: [
							puissance!=-1 ? Container(
								transform: Matrix4.translationValues(0.0, offset_text, 0.0),
								child: Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										Text(
											puissance.toString(),
											textAlign: TextAlign.center,
											style: CustomStyle.nb_kw,
										),
										_kWText(),
									],
								),
								width: MediaQuery.of(context).size.width,
							) : SizedBox(),
							Container(width: MediaQuery.of(context).size.width,child: Image.asset(asset)),
						],
					),
				),
			],
		);
  }

	Widget _kWText() {
		return ClipRect(
			child: new Stack(
				children: [
					new Positioned(
						top: 1.0,
						left: 1.0,
						child: new Text(
							"kW",
							style: CustomStyle.kw_style_home
								.copyWith(color: Colors.white.withOpacity(0.5)),
						),
					),
					new BackdropFilter(
						filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
						child: new Text("kW", style: CustomStyle.kw_style_home),
					),
				],
			),
		);
	}

	Widget _modeleText(String modele) {
		return ClipRect(
			child: new Stack(
				children: [
					new Positioned(
						top: 1.0,
						left: 1.0,
						child: new Text(
							modele,
							style: CustomStyle.modele_style_home
								.copyWith(color: Colors.white.withOpacity(0.5)),
						),
					),
					new BackdropFilter(
						filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
						child: new Text(modele, style: CustomStyle.modele_style_home),
					),
				],
			),
		);
	}

}
