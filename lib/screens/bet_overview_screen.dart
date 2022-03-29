import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitup/screens/single_bet_screen.dart';
import 'package:fitup/widgets/bet_image_picker.dart';
import 'package:flutter/material.dart';

class BetHistoryScreen extends StatefulWidget {
  const BetHistoryScreen({Key key}) : super(key: key);

  @override
  State<BetHistoryScreen> createState() => _BetHistoryScreenState();
}

class _BetHistoryScreenState extends State<BetHistoryScreen> {
  final Stream<QuerySnapshot> _betsStream =
      FirebaseFirestore.instance.collection('bets').snapshots();
  String docId;

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
                docId = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return ListTile(
                  trailing: IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.cloud_upload),
                    onPressed: () => goToBetImagePickerScreen(),
                  ),
                  title: Text(data['action']),
                  subtitle: InkWell(
                    onTap: () => goToSingleBetScreen(data),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Time: ${data['time']}"),
                        Text("Duration: ${data['duration']}"),
                        Text("Value: ${data['value']}€"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ));
  }

  void goToBetImagePickerScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BetImagePicker(
          docId: docId,
        ),
      ),
    );
  }

  void goToSingleBetScreen(data) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SingleBetScreen(
        docId: docId,
        data: data,
      ),
    ));
  }
}
