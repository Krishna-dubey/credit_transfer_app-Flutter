import 'package:credittransferapp/Services/AuthServices.dart';
import 'package:credittransferapp/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MaterialApp(
  home:MyApp()
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value:AuthServices().user,
        child: Wrapper(),
    );
  }
}

