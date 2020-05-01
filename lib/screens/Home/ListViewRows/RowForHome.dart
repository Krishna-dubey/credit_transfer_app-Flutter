import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credittransferapp/Services/AuthServices.dart';
import 'package:credittransferapp/Services/DatabaseServices.dart';
import 'package:credittransferapp/screens/Home/Models/ModelForHome.dart';
import 'package:credittransferapp/screens/Transaction/TransferCredit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class RowForHome extends StatelessWidget {
  ModelForHome data;
  String currentUserUid;

  RowForHome(this.data, this.currentUserUid);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>StreamProvider<FirebaseUser>.value(
              value: AuthServices().user,
              child: StreamProvider<DocumentSnapshot>.value(
                  value: DatabaseService(data.uid).userProfile,
                  child: TransferCredit(data.uid,currentUserUid)),
            )
        ));
      },
      child: Card(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage:NetworkImage(data.imageUrl) ,
                    radius: 30,
                  ),
                )
            ),
            Expanded(
                flex:8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0,0,0,5),
                        child: Text(data.name),
                      ),
                      Text(
                          "credits: "+data.credits,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    ],
                  )
                ))
          ],
        ),
      ),
    );
  }
}
