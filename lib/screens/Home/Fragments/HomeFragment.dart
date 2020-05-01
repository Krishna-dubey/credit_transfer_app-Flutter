import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credittransferapp/screens/Home/Models/ModelForHome.dart';
import 'package:credittransferapp/screens/Home/ListViewRows/RowForHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  List rows=[];

  @override
  Widget build(BuildContext context) {
    final users=Provider.of<QuerySnapshot>(context);
    final currentUser=Provider.of<FirebaseUser>(context);
    rows.clear();
    if(users == null) return Center(child: CircularProgressIndicator());
    for(var user in users.documents){
      if(user['uid']!=currentUser.uid){
        rows.add(ModelForHome(user.data['imageUrl'],user.data['name'],user.data["credits"],user.data['uid']));
      }
    }
//    rows.map((data){return RowForHome(data);}).toList()
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context,index){
        return RowForHome(rows[index],currentUser.uid);
      },
    );
  }
}
