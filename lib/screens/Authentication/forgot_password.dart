import 'package:credittransferapp/Services/AuthServices.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ProgressDialog progressDialog;
  String email="";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    progressDialog=ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: true);
    progressDialog.style(message:"Generating password reset link...");
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.brown[900],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height:10.0),
                  TextFormField(
                    onChanged: (val){
                      setState(() {
                        email=val;
                      });
                    },
                    validator: (val){
                      if(val.length==0){
                        return "Email field cannot be empty";
                      }else if(!EmailValidator.validate(val)){
                        return "Not a valid email address";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "example@domain.com",
                        labelStyle: TextStyle(
                            color: Colors.brown[900]
                        ),
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
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
                  SizedBox(height: 40.0,),
                  RaisedButton(
                    onPressed: () async{
                      if(_formKey.currentState.validate()){
                        await progressDialog.show();
                        String result= await AuthServices().resetPassword(email);
                        progressDialog.hide();
                        if(result!=null){
                          Fluttertoast.showToast(msg: result.toString(),toastLength: Toast.LENGTH_LONG);
                        }else{
                          Fluttertoast.showToast(msg: "reset password link sent to registered email address",toastLength: Toast.LENGTH_LONG);
                        }
                      }

                    },
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.brown[900],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
