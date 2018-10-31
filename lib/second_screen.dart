import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SecondScreen extends StatefulWidget {
  final value;
  SecondScreen(this.value);

  @override
  SecondScreenState createState() {
    return new SecondScreenState();
  }
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class SecondScreenState extends State<SecondScreen> {

_iconBuilder(IconData icon, String status, MaterialColor color){
    return new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color:color,size: 95.0,),
            new Text(status)
          ],
    );
  }
  _buildChild(int machinestatus){
    print("machine status"+machinestatus.toString());
    if(machinestatus == 0){
      return _iconBuilder(Icons.airline_seat_individual_suite, "OFF", Colors.blue);
    }
     if(machinestatus == 1){
      return _iconBuilder(Icons.flash_on, "ON", Colors.green);
    }
     if(machinestatus == 3){
      return _iconBuilder(Icons.broken_image, "Problem", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
 var data = [
      new ClicksPerYear('Problem', 12, Colors.red),
      new ClicksPerYear('Off time', 32, Colors.yellow),
      new ClicksPerYear('On Time', 65, Colors.green),
    ];

    var series = [
      new charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
    );

     var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.value["machinename"]),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildChild(widget.value["machineStaus"]),
            chartWidget,
          ],
      ),
      )
    );
  }
}