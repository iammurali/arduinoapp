import 'package:flutter/material.dart';
import 'dart:async';
import 'package:arduinoapp/services/shared_preferencetest.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: MyCustomForm(),
    );
  }
}

// class _SettingsPageState extends State<SettingsPage> {
  
// }

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  String ipadress;
  // String finalip;

  void _submitForm() async{
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('error')));

    } else {
      // form.save(); //This invokes each onSaved event

      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        print("obje*****&&&&&&&&&&&&&&&************ct"+this.ipadress);
        final bool result = await SharedPreferencesTest().setIpAddress(this.ipadress);
             if (result) {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('result saved')));
                // this.setState(()async{
                //    ipadress = await SharedPreferencesTest().getIpAdress();
                //  Scaffold.of(context).showSnackBar(SnackBar(content: Text(ipadress))); 
                // });
             } else{
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Error while saving')));
             }
                
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
            onSaved: (String value){
                this.ipadress = value;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: _submitForm,
              //  () {
              //   // Validate will return true if the form is valid, or false if
              //   // the form is invalid.
              //   if (_formKey.currentState.validate()) {
              //     // If the form is valid, we want to show a Snackbar
              //     Scaffold.of(context)
              //         .showSnackBar(SnackBar(content: Text('Processing Data')));

                    
              //   }
              // },
              child: Text('Submit'),
            ),
          ),
          // new Text(this.ipadress ?? "null")
        ],
      ),
    );
  }
}