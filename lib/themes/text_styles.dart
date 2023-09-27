import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';

abstract class AppStyles {
  static const TextStyle accentText = TextStyle(color: AppColors.accent);
  static const TextStyle accentText16B = TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle whiteText = TextStyle(color: AppColors.white);
  static const TextStyle whiteTextB = TextStyle(color: AppColors.white, fontWeight: FontWeight.bold);
  static const TextStyle greyText = TextStyle(color: AppColors.grey1);
  static const TextStyle greyText2 = TextStyle(color: AppColors.grey2);
  static const TextStyle whiteCourier = TextStyle(color: AppColors.white, fontFamily: 'Courier');
  static const TextStyle whiteCourierB = TextStyle(color: AppColors.white, fontFamily: 'Courier', fontSize: 18);
  static const TextStyle whiteText32 = TextStyle(color: AppColors.white, fontSize: 32);
  static const TextStyle whiteText32B = TextStyle(color: AppColors.white, fontSize: 32, fontWeight: FontWeight.bold);
  static const TextStyle whiteText40 = TextStyle(color: AppColors.white, fontSize: 40, fontWeight: FontWeight.bold);
  static const TextStyle whiteText40T = TextStyle(color: AppColors.white, fontSize: 40, fontWeight: FontWeight.bold, fontFeatures: [
    FontFeature.tabularFigures()
  ]);
  static const TextStyle whiteText24 = TextStyle(color: AppColors.white, fontSize: 24);
  static const TextStyle whiteText18 = TextStyle(color: AppColors.white, fontSize: 18);
  static const TextStyle darkText18 = TextStyle(color: AppColors.black, fontSize: 18);
  static const TextStyle whiteText16 = TextStyle(color: AppColors.white, fontSize: 16);
  static const TextStyle darkText = TextStyle(color: AppColors.black);
  static const TextStyle darkText14B = TextStyle(color: AppColors.black, fontSize: 14, fontWeight: FontWeight.bold);
  static const TextStyle darkText24Bold = TextStyle(color: AppColors.black, fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle darkText16 = TextStyle(color: AppColors.black, fontSize: 16);
  static const TextStyle greyText10 = TextStyle(color: AppColors.grey2, fontSize: 10);
  static const TextStyle darkText10 = TextStyle(color: AppColors.black2, fontSize: 10);
  static const TextStyle grayText16 = TextStyle(color: AppColors.black2, fontSize: 16);
  static const TextStyle greyText12 = TextStyle(color: AppColors.grey1, fontSize: 12);

  static const radius = 20.0;
  static const corner = Radius.circular(radius);

  static final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: const BorderSide(color: AppColors.grey1, width: 0.5),
  );

  static final inputBorderW = OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: const BorderSide(color: AppColors.white, width: 1.5),
  );
  static final inputBorderW2 = OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: const BorderSide(color: AppColors.white, width: 2.5),
  );

  static const inputBorderZero = OutlineInputBorder(
    borderRadius: BorderRadius.only(topRight: corner, bottomRight: corner),
    borderSide: BorderSide(color: AppColors.grey1, width: 0.5),
  );


  static const double cardBorderRadius = 25;
  static const borderHeader = BorderRadius.only(
    bottomRight: Radius.circular(cardBorderRadius),
    bottomLeft: Radius.circular(cardBorderRadius),
  );

  static const borderBottom = BorderRadius.only(
    topRight: Radius.circular(cardBorderRadius),
    topLeft: Radius.circular(cardBorderRadius),
  );
  static const borderBottom2 = BorderRadius.only(
    topRight: Radius.circular(cardBorderRadius*1.5),
    topLeft: Radius.circular(cardBorderRadius*1.5),
  );

  static BorderRadius borderAll([double radius = cardBorderRadius]) => BorderRadius.all(Radius.circular(radius));

  static const borderLeft = BorderRadius.only(
    bottomLeft: Radius.circular(cardBorderRadius),
    topLeft: Radius.circular(cardBorderRadius),
  );

  static final boxShadow = [
    BoxShadow(
      blurRadius: 10,
      color: Colors.white.withOpacity(.07),
    )
  ];

  static const border1 = BorderRadius.all(Radius.circular(cardBorderRadius),);
  static const underLineDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(width: 2.0, color: Color(0xffdddddd)),
    ),
  );

}


