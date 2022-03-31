import 'package:fitup/providers/AuthenticationService.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fit-up"),
        actions: <Widget>[
          IconButton(
              onPressed: () => {
                    NavigationHelper().goToBetHistoryScreen(context),
                  },
              icon: const Icon(Icons.history)),
          IconButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },

            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Hold yourself accountable by betting on your goals!",
              style: TextStyle(fontSize: 24)),
          const Divider(
            height: 200,
          ),
          OutlinedButton.icon(
            onPressed: () => {
              NavigationHelper().goToCreateBetScreen(context),
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Bet'),
          )
        ],
      ),
    );
  }
}
