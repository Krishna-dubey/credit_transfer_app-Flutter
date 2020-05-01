import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credittransferapp/Services/DatabaseServices.dart';
import 'package:credittransferapp/screens/Transaction/ModelForTransaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../Home/Models/ModelForUsers.dart';

class MaterialDialog extends StatefulWidget {
  final String toTransferUid;
  final User toUserData;

  MaterialDialog(this.toTransferUid,this.toUserData);

  @override
  _MaterialDialogState createState() => _MaterialDialogState();
}

class _MaterialDialogState extends State<MaterialDialog> {

  ProgressDialog progressDialog;
  String credits;
  //form key
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String toTransferUid=widget.toTransferUid;
    User toUserData=widget.toUserData;

    progressDialog=ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: true);
    progressDialog.style(message:"Transfer in progress...");

    DocumentSnapshot profileDetails=Provider.of<DocumentSnapshot>(context);

    //if null then show loading by progress bar
    if(profileDetails == null) return Center(child: CircularProgressIndicator());

    //preapre user object
    User fromUserData = User(profileDetails.data['name'],profileDetails.data['gender'],profileDetails.data['email'],
        profileDetails.data['credits'],profileDetails.data['imageUrl'],profileDetails.data['uid']);


    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Available Credits: "+fromUserData.credits,
                  style: TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        onChanged: (val){
                          setState(() {
                            credits=val;
                          });
                        },
                        validator: (val){
                          if(val.length==0){
                            return "Please enter credit amount";
                          }else if(int.parse(credits)>int.parse(fromUserData.credits)){
                            return "Please enter valid amount";
                          }else if(int.parse(credits)==0){
                            return "Please enter valid amount";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.brown[900]
                            ),
                            labelText: "Credits",
                            prefixIcon: Icon(
                              Icons.attach_money,
                              color: Colors.brown[900],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.brown[900]
                              ),
                            )
                        ),
                      ),
                    SizedBox(height: 30,),
                    RaisedButton(
                      color: Colors.brown[900],
                      child: Text(
                          "Transfer",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      onPressed: ()async{

                        if(_formKey.currentState.validate()){
                          String transactionAmount=credits;
                          String  updatedCreditsFrom=(int.parse(fromUserData.credits)-int.parse(credits)).toString();
                          String  updatedCreditsTo=(int.parse(credits)+int.parse(toUserData.credits)).toString();

                          final df = DateFormat.yMd().add_jm();
                          String dateAndTime=df.format(DateTime.now());


                          await progressDialog.show();

                          ModelForTransaction transactionFrom=ModelForTransaction(fromUserData.uid,"to",toUserData.name,transactionAmount,dateAndTime);
                          ModelForTransaction transactionTo=ModelForTransaction(toUserData.uid,"from",fromUserData.name,transactionAmount,dateAndTime);

                          await DatabaseService(fromUserData.uid).updateUserCredit(updatedCreditsFrom).then((result) async{
                            await DatabaseService(toTransferUid).updateUserCredit(updatedCreditsTo).then((result) async{
                              await DatabaseService(fromUserData.uid).storeTransaction(transactionFrom).then((result) async{
                                await DatabaseService(toUserData.uid).storeTransaction(transactionTo).then((result){
                                  Fluttertoast.showToast(msg: "Credits transfered successfully",toastLength: Toast.LENGTH_LONG);
                                  progressDialog.hide();
                                  Navigator.pop(context);
                                }).catchError((e){
                                  Fluttertoast.showToast(msg: "error: "+e.message,toastLength: Toast.LENGTH_LONG);
                                  progressDialog.hide();
                                  Navigator.pop(context);
                                });
                              }).catchError((e){
                                Fluttertoast.showToast(msg: "error: "+e.message,toastLength: Toast.LENGTH_LONG);
                                progressDialog.hide();
                                Navigator.pop(context);
                              });
                            }).catchError((e){
                              Fluttertoast.showToast(msg:"error: "+ e.message,toastLength: Toast.LENGTH_LONG);
                              progressDialog.hide();
                              Navigator.pop(context);
                            });
                          }).catchError((e){
                            Fluttertoast.showToast(msg:"error: "+e.message,toastLength: Toast.LENGTH_LONG);
                            progressDialog.hide();
                            Navigator.pop(context);
                          });
                        }

                      },
                    )],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
