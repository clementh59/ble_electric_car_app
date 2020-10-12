import 'package:flutter/material.dart';

import 'custom_colors.dart';

class CustomStyle{

	static const FontWeight EXTRALIGHT = FontWeight.w100;
	static const FontWeight THIN = FontWeight.w200;
	static const FontWeight LIGHT = FontWeight.w300;
	static const FontWeight REGULAR = FontWeight.w400;
	static const FontWeight MEDIUM = FontWeight.w500;
	static const FontWeight SEMIBOLD = FontWeight.w600;
	static const FontWeight BOLD = FontWeight.w700;
	static const FontWeight EXTRABOLD = FontWeight.w800;
	static const FontWeight BLACK = FontWeight.w900;

	static TextStyle connectionButtonStyle = TextStyle(
		color: CustomColors.white,
		fontSize: 12,
		fontFamily: 'Poppins',
		fontWeight: BOLD,
	);

	static TextStyle textIndicator = TextStyle(
		color: CustomColors.white,
		fontSize: 18,
		fontFamily: 'Poppins',
		fontWeight: BOLD,
	);

	static TextStyle greyTextIndicator = TextStyle(
		color: CustomColors.grey,
		fontSize: 18,
		fontFamily: 'Poppins',
		fontWeight: BOLD,
	);

	static TextStyle title = TextStyle(
		color: CustomColors.white,
		fontSize: 24,
		fontFamily: 'Poppins',
		fontWeight: EXTRABOLD,
	);

	static TextStyle blueTextIndicator = TextStyle(
		color: CustomColors.blue,
		fontSize: 18,
		fontFamily: 'Poppins',
		fontWeight: BOLD,
	);

	static TextStyle marque_style_home = TextStyle(
		color: CustomColors.greyLighter,
		fontSize: 19,
		fontFamily: 'Poppins',
		fontWeight: MEDIUM,
	);

	static TextStyle modele_style_home = TextStyle(
		color: CustomColors.white,
		fontSize: 32,
		fontFamily: 'Poppins',
		fontWeight: BOLD,
	);

	static TextStyle tap_to_open_the_car = TextStyle(
		color: CustomColors.greyLighter,
		fontSize: 14,
		fontFamily: 'Poppins',
		fontWeight: BOLD,
	);

	static TextStyle nb_kw = TextStyle(
		color: CustomColors.white,
		fontSize: 80,
		fontFamily: 'Poppins',
		fontWeight: THIN,
	);

	static TextStyle kw_style_home = TextStyle(
		color: CustomColors.white,
		fontSize: 15,
		fontFamily: 'Poppins',
		fontWeight: SEMIBOLD,
	);

	static TextStyle title_dashboard = TextStyle(
		color: CustomColors.white,
		fontSize: 16,
		fontFamily: 'Poppins',
		fontWeight: BOLD,
	);



}