import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BetHistoryScreen extends StatefulWidget {
  const BetHistoryScreen({Key key}) : super(key: key);

  @override
  State<BetHistoryScreen> createState() => _BetHistoryScreenState();
}

class _BetHistoryScreenState extends State<BetHistoryScreen> {
  final Stream<QuerySnapshot> _betsStream = FirebaseFirestore.instance.collection('bets').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bet history"),
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: _betsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['action']),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Time: ${data['time']}"),
                  Text("Duration: ${data['duration']}"),
                  Text("Value: ${data['value']}€"),
                ],
              ),
            );
          }).toList(),
        );
      },
    ));
  }
}
