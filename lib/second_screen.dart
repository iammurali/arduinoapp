import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
//import 'package:octal_clock/octal_clock.dart';

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
    if(machinestatus == 4){
      return _iconBuilder(Icons.broken_image, "MACHINE STATUS : DOWN", Colors.yellow);
    }
     if(machinestatus == 1){
      return _iconBuilder(Icons.broken_image, "MACHINE STATUS: RUN", Colors.green);
    }
     if(machinestatus == 3){
      return _iconBuilder(Icons.broken_image, "MACHINE STATUS: STOP", Colors.red);
    }
    if(machinestatus == 0){
      return _iconBuilder(Icons.broken_image, "MACHINE STATUS: OFF", Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {

    _printMachineStatus(){

      if(widget.value["machineStaus"]==1){return new Text("MACHINE STATUS : RUNNING");}
      if(widget.value["machineStaus"]==4){return new Text("MACHINE STATUS : DOWN");}
      if(widget.value["machineStaus"]==3){return new Text("MACHINE STATUS : STOPED");}
      if(widget.value["machineStaus"]==0){return new Text("MACHINE STATUS : OFF");}

    }

//GRAPH
    var data = [
      new ClicksPerYear('STOP TIME', widget.value["problemtime"].round(), Colors.red),
      new ClicksPerYear('RUN TIME', widget.value["elapsedTime"].round(), Colors.green),
      new ClicksPerYear('DOWN TIME', widget.value["idleTime"].round(), Colors.yellowAccent),
      new ClicksPerYear('OFF TIME',widget.value["offtimeB"].round(),Colors.blue),
//           new ClicksPerYear('TIME', widget.value["idleTime"].round(), Colors.green)
    ];

    var series = [
      new charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        labelAccessorFn: (ClicksPerYear clickData, _) => clickData.clicks.toString(),
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
      vertical: false,
      // primaryMeasureAxis: ,
       barRendererDecorator: new charts.BarLabelDecorator<String>(
          insideLabelStyleSpec: new charts.TextStyleSpec(color: charts.Color(r: 0, g: 0, b: 0)),
          outsideLabelStyleSpec: new charts.TextStyleSpec(color: charts.Color(r: 255, g: 255, b: 255))
       ),
       
    );

     var chartWidget = new Container(
      // margin: const EdgeInsets.all(1.0),
      color: const Color(0xFF607D8B),
      child: new SizedBox(
        height: 200.0,
        width: 300.0,
        child: chart,
      ),
    );


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.value["machinename"]),
      ),





        body: SingleChildScrollView(child:new Center(
        child: new Column(
          children: <Widget>[
            new  Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton( onPressed: () => {}, child: Text(""),padding: EdgeInsets.all(5.0),),
                Chip(

                    label: Text(' B ',style: TextStyle(color: Colors.cyanAccent))
                ),
                Chip(

                    label: Text(' A ',style: TextStyle(color: Colors.cyanAccent))
                ),
                Chip(

                    label: Text(' C ',style: TextStyle(color: Colors.cyanAccent))
                ),

                Container(
                   padding: EdgeInsets.fromLTRB(0.0, 0.0, 21.0, 0.0),
                ),
              ],
            ),
            new  Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton( onPressed: () => {}, child: Text(""),padding: EdgeInsets.all(2.0),),
                Chip(
                  label: Text('8.00 - 4.15'),
                ),
                Chip(
                  label: Text('4.15 - 24.00'),
                ),
                Chip(
                  label: Text('00.0-8.0'),
                ),
              ],
            ),
            new  Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(color: Colors.black54, onPressed: () => {}, child: Text("RUN TIME    : "),padding: EdgeInsets.all(5.0),),
                FlatButton(color: Colors.green, onPressed: () => {}, child: Text(widget.value["elapsedTimeB"].toString()+"%",style: TextStyle(color: Colors.black))),
                FlatButton(color: Colors.green, onPressed: () => {}, child: Text(widget.value["elapsedTimeA"].toString()+"%",style: TextStyle(color: Colors.black))),
                FlatButton(color: Colors.green, onPressed: () => {}, child: Text(widget.value["elapsedTimeC"].toString()+"%",style: TextStyle(color: Colors.black)))

              ],
            ),
            new  Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(color: Colors.black54, onPressed: () => {}, child: Text("DOWN TIME :"),padding: EdgeInsets.all(5.0),),
                FlatButton(color: Colors.yellow, onPressed: () => {}, child: Text(widget.value["idleTimeB"].toString()+"%",style: TextStyle(color: Colors.black))),
                FlatButton(color: Colors.yellow, onPressed: () => {}, child: Text(widget.value["idleTimeA"].toString()+"%",style: TextStyle(color: Colors.black))),
                FlatButton(color: Colors.yellow, onPressed: () => {}, child: Text(widget.value["idleTimeC"].toString()+"%",style: TextStyle(color: Colors.black)))
              ],
            ),
            new  Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(color: Colors.black54, onPressed: () => {}, child: Text("STOP TIME : "),padding: EdgeInsets.all(5.0),),
                FlatButton(color: Colors.redAccent, onPressed: () => {}, child: Text(widget.value["problemtimeB"].toString()+"%",style: TextStyle(color: Colors.black))),
                FlatButton(color: Colors.redAccent, onPressed: () => {}, child: Text(widget.value["problemtimeA"].toString()+"%",style: TextStyle(color: Colors.black))),
                FlatButton(color: Colors.redAccent, onPressed: () => {}, child: Text(widget.value["problemtimeC"].toString()+"%",style: TextStyle(color: Colors.black)))
              ],
            ),
            new  Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(color: Colors.black54, onPressed: () => {}, child: Text("OFF TIME   :"),padding: EdgeInsets.all(5.0),),
                FlatButton(color: Colors.blue, onPressed: () => {}, child: Text(widget.value["offtimeB"].toString()+"%",style: TextStyle(color: Colors.black))),
                FlatButton(color: Colors.blue, onPressed: () => {}, child: Text(widget.value["offtimeA"].toString()+"%",style: TextStyle(color: Colors.black))),
                FlatButton(color: Colors.blue, onPressed: () => {}, child: Text(widget.value["offtimeC"].toString()+"%",style: TextStyle(color: Colors.black)))
              ],
            ),


            new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _printMachineStatus(),

              ],
            ),
            new Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 // ignore: list_element_type_not_assignable
                  chartWidget,
               // new Text("hello world")
              ],
            )
          ],
        )
      ),
        )
    );
  }
}
