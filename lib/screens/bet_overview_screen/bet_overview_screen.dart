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
  bool _loading = false;

  void setLoading() {
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    setLoading();
    String userID = context.watch<User>().uid;
    FirebaseHelper().updateBetActivityStatus(userID);
    Stream<QuerySnapshot<Object>> stream =
        FirebaseHelper().getActiveBetsStream(userID);
    setLoading();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bet overview"),
        ),
        body: _loading == false
            ? StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return ListTile(
                        onTap: () => NavigationHelper()
                            .goToSingleBetScreen(data, document.id, context),
                        trailing: IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.cloud_upload),
                          onPressed: () => NavigationHelper()
                              .goToUploadFileScreen(document.id, context),
                        ),
                        title: Text(data['action']),
                        subtitle: InkWell(
                          key: const ValueKey('betDetails'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Time: ${data['time']}"),
                              TimeHelper().betIsLongerThanADay(data['duration'],
                                      data['startDate'].toDate())
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
              )
            : const CircularProgressIndicator(
                value: null,
              ));
  }
}
