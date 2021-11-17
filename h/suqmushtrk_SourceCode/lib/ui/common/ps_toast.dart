import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PsToast {
  void showToast(String message,
      {Color backgroundColor,
      Color textColor,
      ToastGravity gravity = ToastGravity.BOTTOM,
      Toast length = Toast.LENGTH_SHORT}) {
    backgroundColor ??= RoyalBoardColors.mainColor;
    textColor ??= RoyalBoardColors.white;

    Fluttertoast.showToast(
        msg: message,
        toastLength: length,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor);
  }
}
