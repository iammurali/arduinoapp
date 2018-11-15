import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:arduinoapp/second_screen.dart';
import 'pages/settings.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arduinoapp/services/shared_preferencetest.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.grey[800],
                accentColor:Colors.red,
              ),
      home: DefaultTabController(
        length: 2,
        child: new Scaffold(
          body: TabBarView(
            children: [
              new MyHomePage(),
              // new Container(color: Colors.orange,),
              // new Container(
              //   color: Colors.lightGreen,
              // ),
              new SettingsPage(),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),
              // Tab(
              //   icon: new Icon(Icons.rss_feed),
              // ),
              // Tab(
              //   icon: new Icon(Icons.perm_identity),
              // ),
              Tab(icon: new Icon(Icons.settings),)
            ],
            labelColor: Colors.red,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
          ),
          // backgroundColor: Colors.blue,
        ),
),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data;
  fetchPost() async {
    final String ip = await SharedPreferencesTest().getIpAdress();
  String url = 'http://'+ip+'/mob/getmachines';

    print("thisisthe url" + url);
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
  void initState(){
    super.initState();
    this.fetchPost();
    // this.getIp();
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
      // backgroundColor: Colors.black,
      appBar: new AppBar(
        // backgroundColor: Colors.grey[800],
        title: new Text('Machine List'),
        actions: <Widget>[
          FutureBuilder<String>(
              // get the languageCode, saved in the preferences
              future: SharedPreferencesTest().getIpAdress(),
              initialData: 'en',
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return snapshot.hasData
                    ? _buildFlag(snapshot.data)
                    : Container();
              }),
            ],
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
          
          onPressed: () {
            fetchPost();
          }),
    );
  }

  _buildFlag(String value){
    if(value == "null"){
     return Icon(Icons.broken_image,color:Colors.red);
    }else{
      return  FlatButton(
                onPressed: () => {},
                color: Colors.green,
                padding: EdgeInsets.all(5.0),
                child: Column( // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    Icon(Icons.traffic),
                    Text(value)
                  ],
                ),
              );
    }

  }
}
