import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credittransferapp/Services/DatabaseServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Fragments/HistoryFragment.dart';
import 'Fragments/HomeFragment.dart';
import 'Fragments/ProfileFragment.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current_state=0;

  @override
  Widget build(BuildContext context) {
    final user=Provider.of<FirebaseUser>(context);
    final tabs=[
      StreamProvider<QuerySnapshot>.value(
          value: DatabaseService(user.uid).users,
          child: HomeFragment()),
      StreamProvider<QuerySnapshot>.value(
          value: DatabaseService(user.uid).transaction,
          child: HistoryFragment()),
      StreamProvider<DocumentSnapshot>.value(
          value:DatabaseService(user.uid).userProfile,
          child: ProfileFragment())
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Credit Transfer App"),
        backgroundColor: Colors.brown[900],
      ),
      body: tabs[current_state],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            current_state=index;
          });
        },
        selectedItemColor: Colors.brown[900],
        currentIndex: current_state,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text("History")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile")
          )],
      ),
    );;
  }
}
