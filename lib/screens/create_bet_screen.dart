import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitup/screens/bet_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateBetScreen extends StatefulWidget {
  const CreateBetScreen({Key key}) : super(key: key);

  @override
  State<CreateBetScreen> createState() => _CreateBetScreenState();
}

class _CreateBetScreenState extends State<CreateBetScreen> {
  String dropdownActionValue = "Push-ups";
  String dropdownDurationValue = "1 Day";
  TimeOfDay _time = TimeOfDay(hour: 8, minute: 0);
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Bet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Bet Action"),
                actionValueDropdown(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _selectTime,
                  child: Text('SELECT TIME'),
                ),
                SizedBox(height: 8),
                Text(
                  'Selected time: ${_time.format(context)}',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Bet Duration"),
                durationDropdown(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Bet Value"),
                valueInput(),
              ],
            ),
            FloatingActionButton(
              onPressed: createBet,
              child: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }

  Widget actionValueDropdown() {
    return DropdownButton(
      value: dropdownActionValue,
      icon: const Icon(Icons.arrow_downward),
      items: <String>["Push-ups", "Make bed", "Wake up", "Shower"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        setState(() {
          print(newValue);
          dropdownActionValue = newValue;
        });
      },
    );
  }

  Widget durationDropdown() {
    return DropdownButton(
      value: dropdownDurationValue,
      icon: const Icon(Icons.arrow_downward),
      items: <String>["1 Day", "2 Days", "3 Days", "1 Week"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        setState(() {
          print(newValue);
          dropdownDurationValue = newValue;
        });
      },
    );
  }

  Widget valueInput() {
    return SizedBox(
      height: 50.0,
      width: 100.0,
      child: TextField(
        onSubmitted: (text) => {
          // TODO How to disallow - , .
          _value = int.parse(text),
        },
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: "$_value €"),
      ),
    );
  }

  void createBet() {
    try {
      print(
          " Action ${dropdownActionValue}\n Time ${_time.format(context)}\n Duration ${dropdownDurationValue}\n Value ${_value}€");
      FirebaseFirestore.instance.collection('bets').add(<String, dynamic>{
        "action": dropdownActionValue,
        "time": _time.format(context),
        "duration": dropdownDurationValue,
        "value": _value,
      }).then((value) => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const BetHistoryScreen(),
              ),
            )
          });
    } catch (err) {
      print("Error: $err");
    }
  }

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }
}
