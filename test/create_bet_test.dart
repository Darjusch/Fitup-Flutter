import 'package:fitup/utils/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import '../lib/models/bet.dart';

class MockFirebaseHelper extends Mock implements FirebaseHelper {}

class MockBuildContext extends Mock implements BuildContext {}
// We have to refactor the logic to store the bets in the model and then we can test this better.
void main() {
  final MockFirebaseHelper mockFirebaseHelper = MockFirebaseHelper();
  MockBuildContext _mockContext;
  _mockContext = MockBuildContext();
  Bet bet = Bet(
    notificationID: 1,
    now: DateTime.now(), // maybe a bit later
    context: _mockContext,
    dropdownActionValue: 'Push-ups',
    time: const TimeOfDay(hour: 15, minute: 0),
    dropdownDurationValue: 3,
    value: 20,
    userID: "someuserid",
  );

  setUp(() {});
  tearDown(() {});

  test("create bet", () async {
    when(mockFirebaseHelper.createBet());
  });
}
