import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';

class RbButtons extends StatefulWidget {
  const RbButtons(
      {this.onPressed,
        this.titleText = '',
        this.titleTextAlign = TextAlign.center,
        this.colorData,
        this.width,
        this.gradient,
        this.hasShadow = false,
        this.hasShape = true,
        this.textColor});

  final Function onPressed;
  final String titleText;
  final Color colorData;
  final double width;
  final Gradient gradient;
  final bool hasShadow;
  final bool hasShape;
  final Color textColor;
  final TextAlign titleTextAlign;

  @override
  _PSButtonWidgetState createState() => _PSButtonWidgetState();
}

class _PSButtonWidgetState extends State<RbButtons> {
  Gradient _gradient;
  Color _color;
  @override
  Widget build(BuildContext context) {
    _color = widget.colorData;
    _gradient = null;

    _color ??= RoyalBoardColors.mainColor;

    if (widget.gradient == null && _color == RoyalBoardColors.mainColor) {
      _gradient = LinearGradient(colors: <Color>[
        RoyalBoardColors.mainColor,
        RoyalBoardColors.mainDarkColor,
      ]);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: ShapeDecoration(
        shape: widget.hasShape
            ? const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        )
            : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        color: _gradient == null ? _color : null,
        gradient: _gradient,
        shadows: <BoxShadow>[
          if (widget.hasShadow)
            BoxShadow(
                color: Utils.isLightMode(context)
                    ? _color.withOpacity(0.6)
                    : RoyalBoardColors.mainShadowColor,
                offset: const Offset(0, 4),
                blurRadius: 8.0,
                spreadRadius: 3.0),
        ],
      ),
      child: Material(
        color: RoyalBoardColors.transparent,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: widget.hasShape
            ? const BeveledRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(PsDimens.space8)))
            : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PsDimens.space8),
        ),
        child: InkWell(
          onTap: widget.onPressed,
          highlightColor: RoyalBoardColors.mainDarkColor,
          child: Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: PsDimens.space8, right: PsDimens.space8),
              child: Text(
                widget.titleText.toUpperCase(),
                textAlign: widget.titleTextAlign,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: widget.textColor ?? RoyalBoardColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PSButtonWithIconWidget extends StatefulWidget {
  const PSButtonWithIconWidget(
      {this.onPressed,
        this.titleText = '',
        this.colorData,
        this.width,
        this.gradient,
        this.icon,
        this.iconAlignment = MainAxisAlignment.center,
        this.hasShadow = false});

  final Function onPressed;
  final String titleText;
  final Color colorData;
  final double width;
  final IconData icon;
  final Gradient gradient;
  final MainAxisAlignment iconAlignment;
  final bool hasShadow;

  @override
  _PSButtonWithIconWidgetState createState() => _PSButtonWithIconWidgetState();
}

class _PSButtonWithIconWidgetState extends State<PSButtonWithIconWidget> {
  Gradient _gradient;
  Color _color;
  @override
  Widget build(BuildContext context) {
    _color = widget.colorData;
    _gradient = null;

    _color ??= RoyalBoardColors.mainColor;

    if (widget.gradient == null && _color == RoyalBoardColors.mainColor) {
      _gradient = LinearGradient(colors: <Color>[
        RoyalBoardColors.mainColor,
        RoyalBoardColors.mainDarkColor,
      ]);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: ShapeDecoration(
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        color: _gradient == null ? _color : null,
        gradient: _gradient,
        shadows: <BoxShadow>[
          if (widget.hasShadow)
            BoxShadow(
                color: Utils.isLightMode(context)
                    ? _color.withOpacity(0.6)
                    : RoyalBoardColors.mainShadowColor,
                offset: const Offset(0, 4),
                blurRadius: 8.0,
                spreadRadius: 3.0),
        ],
      ),
      child: Material(
        color: RoyalBoardColors.transparent,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(PsDimens.space8))),
        child: InkWell(
          onTap: widget.onPressed,
          highlightColor: RoyalBoardColors.mainDarkColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: widget.iconAlignment,
            children: <Widget>[
              if (widget.icon != null) Icon(widget.icon, color: RoyalBoardColors.white),
              if (widget.icon != null)
                const SizedBox(
                  width: PsDimens.space8,
                ),
              Text(
                widget.titleText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: RoyalBoardColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
