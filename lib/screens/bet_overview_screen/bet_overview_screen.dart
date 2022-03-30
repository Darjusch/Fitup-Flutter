import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BetHistoryScreen extends StatefulWidget {
  const BetHistoryScreen({Key key}) : super(key: key);

  @override
  State<BetHistoryScreen> createState() => _BetHistoryScreenState();
}

class _BetHistoryScreenState extends State<BetHistoryScreen> {
  final Stream<QuerySnapshot> _betsStream = FirebaseFirestore.instance
      .collection('bets')
      .snapshots(includeMetadataChanges: true);
  var dateFormat = DateFormat('dd/MM/yyyy, HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bet overview"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _betsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;
                ;
                return ListTile(
                  trailing: IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.cloud_upload),
                    onPressed: () => NavigationHelper().goToBetImagePickerScreen(document.id, context),
                  ),
                  title: Text(data['action']),
                  subtitle: InkWell(
                    onTap: () => NavigationHelper().goToSingleBetScreen(data, document.id, context),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                    Text("Time: ${data['time']}"),
                    int.parse(data['duration']) - (DateTime
                        .now()
                        .difference(data['startDate'].toDate())
                        .inDays) > 0
                        ? Text(
                        "Time left: ${int.parse(data['duration']) - (DateTime
                            .now()
                            .difference(data['startDate'].toDate())
                            .inDays)} days")
                        : Text(
                      "Time left: ${int.parse(data['duration']) - (DateTime
                          .now()
                          .difference(data['startDate'].toDate())
                          .inHours)} hours"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ));
  }
}
