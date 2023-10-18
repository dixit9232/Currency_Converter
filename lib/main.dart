import 'dart:convert';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.red),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController amount = TextEditingController();
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  Map m = {};
  bool temp = false;

  Future get() async {
    var url = Uri.parse('https://dixit987.000webhostapp.com/converter.php');
    var response = await http.post(url,
        body: {'amount': amount.text, 'from': from.text, 'to': to.text});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    m = jsonDecode(response.body);
    temp=false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                      controller: amount,
                      keyboardType: TextInputType.number,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Enter Amount",
                      ))),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                      controller: from,
                      onTap: () {
                        showCurrencyPicker(
                          context: context,
                          onSelect: (Currency currency) {
                            from.text = currency.code;
                          },
                        );
                      },
                      keyboardType: TextInputType.none,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "From Currency",
                          suffixIcon: Icon(Icons.expand_more_rounded)))),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                      onTap: () {
                        showCurrencyPicker(
                          context: context,
                          onSelect: (Currency currency) {
                            to.text = currency.code;
                          },
                        );
                      },
                      controller: to,
                      keyboardType: TextInputType.none,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "To Currency",
                          suffixIcon: Icon(Icons.expand_more_rounded)))),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          (m['result'] != null && temp==false)
              ? Text(
                  m['result'].toString(),
                  style: TextStyle(fontSize: 30, color: Colors.red),
                )
              : (temp)
                  ? CircularProgressIndicator()
                  : Text("0",
                      style: TextStyle(fontSize: 30, color: Colors.red)),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                if (amount.text != "" && to.text != "" && from.text != "") {
                  temp=true;
                  get();
                } else {
                  Fluttertoast.showToast(msg: "Fill all field");
                }
                setState(() {});
              },
              child: Text('Convert')),
        ],
      )),
    );
  }
}
