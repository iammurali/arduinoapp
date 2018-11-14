import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:arduinoapp/second_screen.dart';

import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'http://192.168.43.94:8081/mob/getmachines';
  List data;
  fetchPost() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      setState(() {
        var extractdata = json.decode(response.body);
        print(extractdata);
        data = extractdata;
      });
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    this.fetchPost();
    print("heueudladsaljdfldsadfasd");
  }

  _iconBuilder(IconData icon, String status, MaterialColor color) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[Icon(icon, color: color), new Text(status)],
    );
  }

  _buildChild(int machinestatus) {
    print("machine status" + machinestatus.toString());
    if (machinestatus == 0) {
      return _iconBuilder(
          Icons.airline_seat_individual_suite, "OFF", Colors.blue);
    }
    if (machinestatus == 1) {
      return _iconBuilder(Icons.flash_on, "ON", Colors.green);
    }
    if (machinestatus == 3) {
      return _iconBuilder(Icons.broken_image, "PROBLEM", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Machine List'),
      ),
      body: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            return new ListTile(
              title: new Text(data[i]["machinename"]),
              subtitle: new Text(data[i]["elapsedTime"].toString()),
              trailing:  _buildChild(data[i]["machineStaus"]),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecondScreen(data[i])));
              },
              // leading: new CircleAvatar(
              //   backgroundImage:
              //       new NetworkImage('https://cdn3.iconfinder.com/data/icons/gears-4/110/Gearssmall-512.png'),
              // )
            );
          }),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.refresh),
          backgroundColor: Colors.blue,
          onPressed: () {
            fetchPost();
          }),
    );
  }
}
