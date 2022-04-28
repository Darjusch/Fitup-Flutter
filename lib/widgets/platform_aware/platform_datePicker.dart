import 'package:fitup/utils/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlatformDatePicker
    extends PlatformWidget<CupertinoDatePicker, TextButton> {
  const PlatformDatePicker(
      {Key key, this.onPressed, this.selectedTime, this.onDateTimeChanged})
      : super(key: key);

  final GestureTapCallback onPressed;
  final TimeOfDay selectedTime;
  final Function(DateTime) onDateTimeChanged;
  @override
  CupertinoDatePicker buildCuppertinoWidget(BuildContext context) {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      onDateTimeChanged: onDateTimeChanged,
      initialDateTime: DateTime.now(),
    );
  }

  @override
  TextButton buildMaterialWidget(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Row(
        children: [
          Text(selectedTime.format(context),
              style: TextStyle(
                  fontSize: 17.sp,
                  decoration: TextDecoration.underline,
                  color: (Colors.grey[700]),
                  decorationThickness: 0.5,
                  decorationColor: (Colors.grey[500]))),
          Icon(
            Icons.arrow_downward,
            color: (Colors.grey[700]),
          )
        ],
      ),
    );
  }
}
