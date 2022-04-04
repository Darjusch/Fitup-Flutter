import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/utils/time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BetHistoryScreen extends StatefulWidget {
  const BetHistoryScreen({Key key}) : super(key: key);

  @override
  State<BetHistoryScreen> createState() => _BetHistoryScreenState();
}

class _BetHistoryScreenState extends State<BetHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    String userID = context.watch<User>().uid;
    FirebaseHelper().updateBetActivityStatus(userID);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Bet overview"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseHelper().getActiveBetsStream(userID),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return ListTile(
                  trailing: IconButton(
                    iconSize: 40,
                    icon: const Icon(Icons.cloud_upload),
                    onPressed: () => NavigationHelper()
                        .goToBetImagePickerScreen(document.id, context),
                  ),
                  title: Text(data['action']),
                  subtitle: InkWell(
                    onTap: () => NavigationHelper()
                        .goToSingleBetScreen(data, document.id, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Time: ${data['time']}"),
                        TimeHelper().betIsLongerThanADay(
                                data['duration'], data['startDate'].toDate())
                            ? Text(
                                "Time left: ${TimeHelper().betHasXDaysLeft(data['duration'], data['startDate'].toDate())} days")
                            : Text(
                                "Time left: ${TimeHelper().betHasXHoursLeft(data['duration'], data['startDate'].toDate())} hours"),
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
