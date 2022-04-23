import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/screens/bets_overview_screen.dart';
import 'package:fitup/screens/create_bet_screen.dart';
import 'package:fitup/screens/home_screen.dart';
import 'package:fitup/screens/profile_screen.dart';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class CustomNavigationWrapper extends StatefulWidget {
  const CustomNavigationWrapper({Key key}) : super(key: key);

  @override
  State<CustomNavigationWrapper> createState() =>
      CustomNavigationWrapperState();
}

class CustomNavigationWrapperState extends State<CustomNavigationWrapper> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const MyHomeScreen(),
    const CreateBetScreen(),
    const BetOverviewScreen(),
    const ProfileScreen(),
  ];

  static final List<String> _titles = <String>[
    'Fit-up',
    'Create Bet',
    'Bet overview',
    'Profile',
  ];

  @override
  void initState() {
    String userID = Provider.of<User>(context, listen: false).uid;

    FirebaseHelper().updateBetActivityStatusAndCancelNotification(userID);
    FirebaseHelper().updateBetSuccessStatus(userID);
    Provider.of<BetProvider>(context, listen: false).loadInitalBets(userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(title: _titles[_selectedIndex], context: context),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 8.h),
            child: GNav(
              rippleColor: Colors.grey[300],
              hoverColor: Colors.grey[100],
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100],
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.plus,
                  text: 'Create',
                ),
                GButton(
                  icon: LineIcons.list,
                  text: 'Overview',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
