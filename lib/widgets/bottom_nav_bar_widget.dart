import 'package:fitup/screens/bet_overview_screen/bet_overview_screen.dart';
import 'package:fitup/screens/create_bet_screen/create_bet_screen.dart';
import 'package:fitup/screens/my_home_screen/my_home_screen.dart';
import 'package:fitup/screens/profile_screen.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300],
              hoverColor: Colors.grey[100],
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
