import 'package:flutter/material.dart';

Widget snackBarWidget(String message, bool isError) {
  return SnackBar(
    content: Text(message),
    backgroundColor: isError == false ? Colors.green : Colors.red,
  );
}
