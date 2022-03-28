import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/bet.dart';

class CreateBetScreen extends StatefulWidget {
  const CreateBetScreen({Key? key}) : super(key: key);

  @override
  State<CreateBetScreen> createState() => _CreateBetScreenState();
}

class _CreateBetScreenState extends State<CreateBetScreen> {
  String dropdownActionValue = "Push-ups";
  String dropdownDurationValue = "1 Day";
  TimeOfDay _time = TimeOfDay(hour: 8, minute: 0);
  int _value = 0;

  List<Bet> bets = [];

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Bet"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text("Bet Action"),
              DropdownButton(
                value: dropdownActionValue,
                icon: const Icon(Icons.arrow_downward),
                items: <String>["Push-ups", "Make bed", "Wake up", "Shower"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    print(newValue);
                    dropdownActionValue = newValue!;
                  });
                },
              )
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
              DropdownButton(
                value: dropdownDurationValue,
                icon: const Icon(Icons.arrow_downward),
                items: <String>["1 Day", "2 Days", "3 Days", "1 Week"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    print(newValue);
                    dropdownDurationValue = newValue!;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text("Bet Value"),
              SizedBox(
                height: 50.0,
                width: 100.0,
                child: TextField(
                  onSubmitted: (text) => {
                    print(text),
                    // How to disallow - , .
                    _value = int.parse(text),
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "$_value €"),
                ),
              ),
            ],
          ),
          FloatingActionButton(
            onPressed: () => {
              bets.add(Bet(
                action: dropdownActionValue,
                time: _time,
                duration: dropdownDurationValue,
                value: _value,
              )),
              print(" Action ${bets[0].action}\n Time ${bets[0].time}\n Duration ${bets[0].duration}\n Value ${bets[0].value}€")
            },
            child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
