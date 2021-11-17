import 'dart:io';

import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:flutter/material.dart';

class PsBackButtonWithCircleBgWidget extends StatelessWidget {
  const PsBackButtonWithCircleBgWidget({Key key, this.isReadyToShow})
      : super(key: key);

  final bool isReadyToShow;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isReadyToShow,
      child: Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12, right: PsDimens.space4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: RoyalBoardColors.black.withAlpha(100),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
                left: Platform.isIOS ? PsDimens.space8 : PsDimens.space1),
            child: InkWell(
                child: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: RoyalBoardColors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                }),
          ),
        ),
      ),
    );
  }
}
