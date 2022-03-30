import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
//1
import 'package:fitup/main.dart';
//2
import 'package:flutter/material.dart';

Future<void> addDelay(int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  if (binding is LiveTestWidgetsFlutterBinding) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }
  group('end-to-end test', () {
    testWidgets('Click one create bet', (WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await addDelay(5000);
      await tester.tap(find.byIcon(Icons.add));

      tester.printToConsole('Bet creation screen opens');

      await tester.pumpAndSettle();
      await addDelay(5000);

      int value = 5;
      await tester.enterText(
          find.byKey(const ValueKey('betValueField')), value.toString());
      await addDelay(5000);

      //TODO: click on create bet
      // TODO: check if bet was created by looking for action using except
    });
  });
}
