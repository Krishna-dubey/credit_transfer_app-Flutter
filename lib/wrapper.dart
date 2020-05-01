import 'package:credittransferapp/main.dart';
import 'package:credittransferapp/screens/Authentication/signin.dart';
import 'package:credittransferapp/screens/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {
    final user=Provider.of<FirebaseUser>(context);
    if(user!=null){
      return Home();
    }else{
      return SignIn();
    }

  }
}
