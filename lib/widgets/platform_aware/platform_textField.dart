import 'package:fitup/utils/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformTextField extends PlatformWidget<CupertinoTextField, TextField> {
  const PlatformTextField({
    Key key,
    this.onSubmitted,
    this.text,
    this.textInputType,
  }) : super(key: key);

  final Function(String) onSubmitted;
  final String text;
  final TextInputType textInputType;

  @override
  CupertinoTextField buildCuppertinoWidget(BuildContext context) {
    return CupertinoTextField(
      keyboardType: textInputType,
      onSubmitted: onSubmitted,
      textAlign: TextAlign.center,
      placeholder: text,
      decoration: BoxDecoration(border: Border.all()),
    );
  }

  @override
  TextField buildMaterialWidget(BuildContext context) {
    return TextField(
      keyboardType: textInputType,
      onSubmitted: onSubmitted,
      textAlign: TextAlign.center,
      decoration:
          InputDecoration(hintText: text, border: const OutlineInputBorder()),
    );
  }
}
