import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credittransferapp/screens/Home/ListViewRows/RowForHistory.dart';
import 'package:credittransferapp/screens/Transaction/ModelForTransaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/ModelForHome.dart';

class HistoryFragment extends StatefulWidget {
  @override
  _HistoryFragmentState createState() => _HistoryFragmentState();
}

class _HistoryFragmentState extends State<HistoryFragment> {
  List rows=[];
  @override
  Widget build(BuildContext context) {
    final transctions=Provider.of<QuerySnapshot>(context);
    rows.clear();
    if(transctions == null) return Center(child: CircularProgressIndicator());
    for(var trans in transctions.documents){
      rows.add(ModelForTransaction(trans.data['uid'], trans.data['type'], trans.data['name'],trans.data['credits'],trans.data['dateAndTime']));

    }
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context,index){
        return RowForHistory(rows[index]) ;
      },
    );
  }
}
