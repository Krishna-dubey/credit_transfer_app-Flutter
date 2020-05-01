import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credittransferapp/Services/DatabaseServices.dart';
import 'package:credittransferapp/screens/Transaction/MaterialDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Home/Models/ModelForUsers.dart';

class TransferCredit extends StatefulWidget {
  final String toUid,CurrentUserUid;

  TransferCredit(this.toUid,this.CurrentUserUid);

  @override
  _TransferCreditState createState() => _TransferCreditState();
}

class _TransferCreditState extends State<TransferCredit> {

  @override
  Widget build(BuildContext context) {
    String uid=widget.toUid;
    String currentUserUid=widget.CurrentUserUid;

    DocumentSnapshot profileDetails=Provider.of<DocumentSnapshot>(context);

    //if null then show loading by progress bar
    if(profileDetails == null) return Center(child: CircularProgressIndicator());

    //preapre user object
    User user = User(profileDetails.data['name'],profileDetails.data['gender'],profileDetails.data['email'],
        profileDetails.data['credits'],profileDetails.data['imageUrl'],profileDetails.data['uid']);

    return Scaffold(
      appBar: AppBar(
        title: Text("Transfer Credits"),
        backgroundColor: Colors.brown[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                    radius: 60,
                  )
              ),
              SizedBox(height: 5,),
              Center(
                child: Text(
                  user.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic
                  ),
                ),
              ),
              SizedBox(height: 50,),
              myRow("Email",user.email),

              SizedBox(height: 30,),
              myRow("Gender",user.gender),
              SizedBox(height: 30,),
              myRow("Credit Balance",user.credits),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: () {
                        showDialog(context: context,builder: (context){
                          return StreamProvider<DocumentSnapshot>.value(
                              value: DatabaseService(currentUserUid).userProfile,
                              child: MaterialDialog(uid,user)
                          );
                        });
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Transfer Credits",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      color: Colors.brown[900]
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container myRow(String field,String value){
    return  Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5,0,0,0),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  field,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,8.0,0.0,0.0),
                  child: Text(
                    value,
                    style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
