import 'package:fitup/utils/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import '../lib/models/bet_model.dart';

class MockFirebaseHelper extends Mock implements FirebaseHelper {}

class MockBuildContext extends Mock implements BuildContext {}
// We have to refactor the logic to store the bets in the model and then we can test this better.
void main() {
  final MockFirebaseHelper mockFirebaseHelper = MockFirebaseHelper();
  MockBuildContext _mockContext;
  _mockContext = MockBuildContext();
  BetModel bet = BetModel(
    notificationID: 1,
    startDate: DateTime.now(), // maybe a bit later
    action: 'Push-ups',
    time: const TimeOfDay(hour: 15, minute: 0),
    duration: 3,
    value: 20,
    userID: "someuserid",
  );

  setUp(() {});
  tearDown(() {});

  test("create bet", () async {
    when(mockFirebaseHelper.createBet());
  });
}
