// import 'package:fitup/models/bet_model.dart';
// import 'package:fitup/providers/bet_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   BetModel _betModel;
//   ChangeNotifierProvider<BetProvider> _controller;

//   setUp(() {
//     _controller =
//         ChangeNotifierProvider<BetProvider>(create: (context) => BetProvider());
//     _betModel = BetModel(
//       betID: "123",
//       action: "Wake up",
//       duration: 3,
//       notificationID: 2,
//       startDate: DateTime.now(),
//       time: const TimeOfDay(hour: 8, minute: 0),
//       userID: "1234",
//       value: 15,
//     );
//   });

//   testWidgets("Create bet", (tester) async {
//     await tester.pumpWidget(ChangeNotifierProvider<BetProvider>(
//         create: (context) => BetProvider()));
//   });
// }
