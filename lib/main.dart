import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/providers/user_provider.dart';
import 'package:fitup/screens/auth_screen/auth_screen.dart';
import 'package:fitup/widgets/bottom_nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/AuthenticationService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (_) {
          return MultiProvider(
            providers: [
              Provider<Auth>(create: (_) => Auth(auth: FirebaseAuth.instance)),
              StreamProvider(
                create: (context) => context.read<Auth>().user,
                initialData: null,
              ),
              ChangeNotifierProvider<BetProvider>(
                  create: (context) => BetProvider()),
              ChangeNotifierProvider<UserProvider>(
                  create: (context) => UserProvider()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Fit-up',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const AuthenticationWrapper(),
            ),
          );
        });
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      debugPrint(firebaseUser.email);
      return const CustomNavigationWrapper();
    } else {
      return const AuthScreen();
    }
  }
}
