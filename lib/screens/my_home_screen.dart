import 'package:fitup/screens/bet_history_screen.dart';
import 'package:fitup/screens/create_bet_screen.dart';
import 'package:flutter/material.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fit-up"),
        actions: <Widget>[
          IconButton(
              onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const BetHistoryScreen()))
                  },
              icon: const Icon(Icons.account_box_rounded))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Keep yourself accountable by betting on your goals!",
              style: TextStyle(fontSize: 24)),
          const Divider(
            height: 200,
          ),
          OutlinedButton.icon(
            onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CreateBetScreen()))
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Bet'),
          )
        ],
      ),
    );
  }
}
