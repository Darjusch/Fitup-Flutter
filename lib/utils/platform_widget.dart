import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PlatformWidget<CuppertinoWidget extends Widget,
    MaterialWidget extends Widget> extends StatelessWidget {
  const PlatformWidget({Key key}) : super(key: key);

  CuppertinoWidget buildCuppertinoWidget(BuildContext context);
  MaterialWidget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildCuppertinoWidget(context);
    } else {
      return buildMaterialWidget(context);
    }
  }
}
