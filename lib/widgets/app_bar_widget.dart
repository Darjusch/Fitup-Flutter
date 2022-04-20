import 'package:fitup/providers/AuthenticationService.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget customAppBar({String title, BuildContext context}) {
  return AppBar(
    title: Text(title),
    actions: <Widget>[
      IconButton(
        onPressed: () {
          Provider.of<BetProvider>(context, listen: false).removeAllBets();
          Provider.of<Auth>(context, listen: false).signOut();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        },
        icon: const Icon(Icons.logout),
      )
    ],
  );
}
