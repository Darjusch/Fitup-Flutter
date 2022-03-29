import 'package:flutter/material.dart';

class SingleBetScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const SingleBetScreen({Key key, @required this.docId, @required this.data})
      : super(key: key);

  @override
  State<SingleBetScreen> createState() => _SingleBetScreenState();
}

class _SingleBetScreenState extends State<SingleBetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bet details"),
      ),
      body: Column(
        children: [
          Text("Action: ${widget.data['action']}"),
          Text("Duration: ${widget.data['duration']}"),
          Text("Time: ${widget.data['time']}"),
          Text("Value: ${widget.data['value']}€"),
          widget.data['images'] != null
              ? Image.network("${widget.data['images']}", width: 250, height: 250,)
              : Text("No Images uploaded yet"),
        ],
      ),
    );
  }
}
