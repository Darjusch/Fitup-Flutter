import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitup/main.dart';
import 'package:flutter/material.dart';

Future<void> addDelay(int sec) async {
  await Future<void>.delayed(Duration(seconds: sec));
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  if (binding is LiveTestWidgetsFlutterBinding) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }
  group('end-to-end test', () {
    String testEmail = "integration_test@fitup.de";
    String testPassword = "123456789";
    int delayDuration = 1;

    testWidgets('End to end test', (WidgetTester tester) async {
      // START
      await Firebase.initializeApp();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await addDelay(delayDuration);

      // SIGNIN
      await tester.enterText(
          find.byKey(const ValueKey('emailField')), testEmail);
      await addDelay(1);
      await tester.enterText(
          find.byKey(const ValueKey('passwordField')), testPassword);
      await addDelay(delayDuration);
      await tester.tap(find.byKey(const ValueKey('Sign in')));
      await addDelay(delayDuration);

      // GO TO CREATE BET
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await addDelay(delayDuration);

      // CREATE BET
      int value = 5;
      await tester.enterText(
          find.byKey(const ValueKey('betValueField')), value.toString());
      await addDelay(delayDuration);

      // GO TO BET OVERVIEW
      await tester.tap(find.byIcon(Icons.add));
      await addDelay(delayDuration);

      // GO TO BET DETAIL SCREEN
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('betDetails')).first);
      await addDelay(delayDuration);

      // GO BACK TO BET OVERVIEW SCREEN
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Back'));
      await addDelay(delayDuration);

      // GO TO UPLOAD IMAGE SCREEN
      await tester.tap(find.byIcon(Icons.cloud_upload).first);
      await addDelay(delayDuration);

      // SELECT AN IMAGE
      // await tester.tap(find.byKey(const ValueKey('galleryKey')));
      // await tester.pumpAndSettle();
      // await tester.tapAt(const Offset(1500, 700));
      // await addDelay(delayDuration);

      // await tester.tapAt(const Offset(500, 300));
      // await tester.tapAt(const Offset(400, 300));
      // await addDelay(delayDuration);

      // await tester.tapAt(const Offset(300, 300));
      // await tester.tapAt(const Offset(200, 300));

      // // UPLOAD AN IMAGE
      // await tester.tap(find.byKey(const ValueKey('uploadKey')));
      // await addDelay(delayDuration);

      // GO TO BET OVERVIEW
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Back'));
      await addDelay(delayDuration);

      // GO TO BET DETAIL SCREEN
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('betDetails')).first);
      await addDelay(delayDuration);
    });
  });
}
