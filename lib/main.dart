import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:arduinoapp/second_screen.dart';
import 'pages/settings.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arduinoapp/services/shared_preferencetest.dart';
//import 'package:octal_clock/octal_clock.dart';
import 'package:intl/intl.dart';

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
  Timer _timer;
  Timer _blinkTimer;
  Color _blinkOnColor;
  Color _blinkProblemColor;
  Color _blinkIdleColor;
  int _blinkStatus;

  @override
  void initState(){
    super.initState();
    this.fetchPost();
    _blinkOnColor = Colors.transparent;
    _blinkStatus = 1;
    // this.getIp();
    const threeSec = const Duration(seconds:3);
     const oneSec = const Duration(seconds:1);
    _timer = new Timer.periodic(threeSec, (Timer t) => this.fetchPost());
    _blinkTimer = new Timer.periodic(oneSec, (Timer t) =>this.changeColor());
  }



  @override
  void dispose() {
    _timer.cancel();
    _blinkTimer.cancel();
    super.dispose();
  }

  changeColor(){
      // print("############****** Blink variable"+ _blinkStatus.toString() + "*********##########");

    if(_blinkStatus == 1){
      // print("############****** Blink variable"+ _blinkStatus.toString() + "*********##########");

        setState(() {
              _blinkOnColor = Colors.lightGreen[400];
              _blinkProblemColor = Colors.redAccent;
              _blinkIdleColor = Colors.yellow[200];
        });
              _blinkStatus = 0;
    }else{
      // print("############****** Blink variable"+ _blinkStatus.toString() + "*********##########");
        setState(() {
                      _blinkOnColor = Colors.transparent;
                      _blinkProblemColor = Colors.transparent;
                      _blinkIdleColor = Colors.transparent;
          });
          _blinkStatus = 1;
    }

  }
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
      print('*************failed to load*****************');
      throw Exception('Failed to load post');
    }
  }

  _iconBuilder(String elapsedTime, String problemTime, String idleTime, Color onColor, Color problemColor, Color IdleColor ) {
    return new  Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
    FlatButton(color: onColor, onPressed: () => {}, child: Text(elapsedTime, style: TextStyle(color: Colors.black),),),
    FlatButton(color: problemColor, onPressed: () => {}, child: Text(problemTime,style: TextStyle(color: Colors.black))),
    FlatButton(color: IdleColor, onPressed: () => {}, child: Text(idleTime,style: TextStyle(color: Colors.black)))
    ],
    );
  }


  _buildChild(int machinestatus, String elapsedTime, String problemTime, String idleTime) {

    print("elapsedTime " + elapsedTime);
    if (machinestatus == 4) {
      return _iconBuilder(elapsedTime, problemTime, idleTime, Colors.lightGreen[400], Colors.redAccent, _blinkIdleColor); //idle

    }
    if (machinestatus == 1) {
      return _iconBuilder(elapsedTime, problemTime, idleTime, _blinkOnColor, Colors.redAccent, Colors.yellow[200]); //on

    }
    if (machinestatus == 3) {
      return _iconBuilder(elapsedTime, problemTime, idleTime,Colors.lightGreen[400], _blinkProblemColor, Colors.yellow[200]);//PROBLEM
    }
    if(machinestatus == 2){
      return _iconBuilder(elapsedTime, problemTime, idleTime,Colors.lightGreen[400], Colors.redAccent, Colors.yellow[200]);
    }
    if(machinestatus == 0){
      return _iconBuilder(elapsedTime, problemTime, idleTime,Colors.lightGreen[400], Colors.redAccent, Colors.yellow[200]);
    }
    if(machinestatus == 5){
      return _iconBuilder(elapsedTime, problemTime, idleTime,Colors.lightGreen[400], Colors.redAccent, Colors.yellow[200]);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(now);
    return new Scaffold(
      // backgroundColor: Colors.black,
      appBar: new AppBar(
        // backgroundColor: Colors.grey[800],
        title: new Text('Machine List', style: TextStyle(fontWeight: FontWeight.bold)),
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
      body:
        new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Row(
              
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                new Container(padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                color: Colors.white,
                child: Text(formattedDate,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.cyanAccent[400])),),
              Text("RUN TIME",style: TextStyle(fontWeight: FontWeight.bold)),
              Text("STOP TIME",style: TextStyle(fontWeight: FontWeight.bold)),
              Text("DOWN TIME",style: TextStyle(fontWeight: FontWeight.bold))
            ],),
            new Expanded(
                child: new Container(
//                  decoration: new BoxDecoration(color: Colors.blue),
//                  height: 200.0,
                  child: new ListView.builder(
                      itemCount: data == null ? 0 : data.length,
                      itemBuilder: (BuildContext context, i) {
                        return new ListTile(
                          title: new Text(data[i]["machinename"]),
//                          subtitle: new Text(data[i]["elapsedTime"].toString()+"%"),
                          trailing: _buildChild(
                              data[i]["machineStaus"],
                              data[i]["elapsedTime"].toString()+"%",
                              data[i]["problemtime"].toString()+"%",
                              data[i]["idleTime"].toString()+"%"
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SecondScreen(data[i]))
                            );
                          },

                        );
                      }),
                )
            )
          ]
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.refresh),
          
          onPressed: () {
            fetchPost();
          }
          ),
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
