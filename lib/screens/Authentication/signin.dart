import 'package:credittransferapp/Services/AuthServices.dart';
import 'package:credittransferapp/screens/Authentication/forgot_password.dart';
import 'package:credittransferapp/screens/Authentication/registration.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../wrapper.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  ProgressDialog progressDialog;
  String email="";
  String password="";
  final _formKey = GlobalKey<FormState>();

  // Initially password is obscure
  bool _obscureText = true;

  Icon password_visibility_icon=Icon(Icons.visibility_off);

  // Toggles the password show status
  void _toggle() {
    setState(() {
      if(_obscureText==false){
        _obscureText=true;
        password_visibility_icon=Icon(Icons.visibility_off);
      }else if(_obscureText==true){
        _obscureText=false;
        password_visibility_icon=Icon(Icons.visibility);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    progressDialog=ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: true);
    progressDialog.style(message:"Signing In");
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
                  SizedBox(height: 30,),
                  TextFormField(
                    onChanged: (val){
                      setState(() {
                        password=val;
                      });
                    },
                    validator: (val){
                      if(val.length==0){
                        return "Password field cannot be empty";
                      }else{
                        return null;
                      }
                    },
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon:password_visibility_icon,
                        color: Colors.brown[900],
                        onPressed: (){
                          _toggle();
                        },
                      ),
                        labelStyle: TextStyle(
                            color: Colors.brown[900]
                        ),
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.vpn_key,
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
                        dynamic result=await AuthServices().signInWithEmailAndPassword(email, password);
                        progressDialog.hide();
                        if(result!=null){
                          Fluttertoast.showToast(msg: result.toString(),toastLength: Toast.LENGTH_LONG);
                        }else{
                          Fluttertoast.showToast(msg: "Sign in Successful",toastLength: Toast.LENGTH_LONG);
                        }
                      }
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.brown[900],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>ForgotPassword()
                            ));
                          },
                          color: Colors.white,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.blue[900]
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context)=>Register()
                            ));
                          },
                          color: Colors.white,
                          child: Text(
                            "Register Here",
                            style: TextStyle(
                                color: Colors.blue[900]
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
