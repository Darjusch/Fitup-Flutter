import 'package:fitup/utils/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformButton extends PlatformWidget<CupertinoButton, MaterialButton> {
  const PlatformButton(
      {Key key, this.text, this.onPressed, this.textColor, this.buttonColor})
      : super(key: key);
  final String text;
  final GestureTapCallback onPressed;
  final Color textColor;
  final Color buttonColor;

  @override
  CupertinoButton buildCuppertinoWidget(BuildContext context) {
    return CupertinoButton(
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        onPressed: onPressed,
        color: buttonColor);
  }

  @override
  MaterialButton buildMaterialWidget(BuildContext context) {
    return MaterialButton(
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        onPressed: onPressed,
        color: buttonColor);
  }
}
