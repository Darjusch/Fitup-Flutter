import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleBetScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const SingleBetScreen({Key key, @required this.docId, @required this.data})
      : super(key: key);

  @override
  State<SingleBetScreen> createState() => _SingleBetScreenState();
}

class _SingleBetScreenState extends State<SingleBetScreen> {
    var dateFormat = DateFormat('dd/MM/yyyy, HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bet details"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
              width: 200,
              child: Column(
            children: [
              Text("Action: ${widget.data['action']}"),
              Text("Duration: ${widget.data['duration']}"),
              Text("Time: ${widget.data['time']}"),
              Text("Value: ${widget.data['value']}€"),

              Text("StartDate: ${dateFormat.format(widget.data['startDate'].toDate())}"),
              Text("isActive: ${widget.data['isActive']}"),
              Text("success: ${widget.data['success']}"),
            ],
          )),

          widget.data['images'] != null
              ? SizedBox(
                  height: 400,
                  width: 400,
                  child: ListView(children: [
                    for (var image in widget.data['images'])
                      Image.network(
                        "${image}",
                        width: 100,
                        height: 100,
                      )
                  ]))
              : Text("No Images uploaded yet"),

//          Image.network("${widget.data['images'][0]}", width: 250, height: 250,)
        ],
      ),
    );
  }
}
