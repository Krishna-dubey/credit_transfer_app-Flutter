import 'package:credittransferapp/Services/AuthServices.dart';
import 'package:credittransferapp/screens/Home/home.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email="";
  String password="";
  String name="";
  String confirmPassword="";
  String gender="Male";
  final _formKey = GlobalKey<FormState>();
  ProgressDialog progressDialog;

  String temp_imageUrl="https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/NYCS-bull-trans-C.svg/1200px-NYCS-bull-trans-C.svg.png";

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
    progressDialog.style(message:"Registering");
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.brown[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                        "Note: You get 1000 credits on successful registraion"
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                      onChanged: (val){
                        setState(() {
                          name=val;
                        });
                      },
                      decoration: getInputDecoration("Name",Icon(Icons.person,color: Colors.brown[900])),
                    validator: (val){
                        if(val.length==0){
                          return "Name field cannot be empty";
                        }else{
                          return null;
                        }
                    },
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0,0,0,0),
                    child: Text(
                      "Gender",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.brown[900]
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                groupValue: gender,
                                activeColor: Colors.brown[900],
                                value: "Male",
                                onChanged: (String val){
                                  setState(() {
                                    gender=val;
                                    print(gender);
                                  });
                                },
                              ),
                              Text(
                                  "Male"
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                groupValue: gender,
                                activeColor: Colors.brown[900],
                                value: "Female",
                                onChanged: (String val){
                                  setState(() {
                                    gender=val;
                                  });

                                },
                              ),
                              Text(
                                  "Female"
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                groupValue: gender,
                                activeColor: Colors.brown[900],
                                value: "Other",
                                onChanged: (String val){
                                  setState(() {
                                    gender=val;
                                  });
                                  },
                              ),
                              Text(
                                  "Other"
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height:30.0),
                  TextFormField(
                    onChanged: (val){
                      setState(() {
                        email=val;
                      });
                    },
                    decoration: getInputDecoration("Email",Icon(Icons.email,color: Colors.brown[900])),
                    validator: (val){
                      if(val.length==0){
                        return "Email field cannot be empty";
                      }else if(!EmailValidator.validate(val)){
                          return "Not a valid email address";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    onChanged: (val){
                      setState(() {
                        password=val;
                      });
                    },
                    obscureText: _obscureText,
                    decoration: getInputDecoration("Password",Icon(Icons.vpn_key,color: Colors.brown[900])),
                    validator: (val){
                      if(val.length<6){
                        return "Min password length is 6";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                      onChanged: (val){
                        setState(() {
                          confirmPassword=val;
                        });
                      },
                      obscureText: _obscureText,
                      decoration: getInputDecoration("Confirm Password",Icon(Icons.vpn_key,color: Colors.brown[900])),
                    validator: (val){
                        if(confirmPassword!=password){
                          return "Password mismatch";
                        }else{
                          return null;
                        }
                    },
                  ),

                  SizedBox(height: 40.0,),
                  Center(
                    child: RaisedButton(
                      onPressed: () async{
                        if(_formKey.currentState.validate()){
                          await progressDialog.show();
                          dynamic result=await AuthServices().registerWithEmailAndPassword(email, password, gender, name,temp_imageUrl);
                          progressDialog.hide();
                          if(result!=null){
                            Fluttertoast.showToast(msg: result.toString(),toastLength:Toast.LENGTH_LONG);
                          }else{
                            Fluttertoast.showToast(msg: "Registeration Successful",toastLength:Toast.LENGTH_LONG);
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.brown[900],
                    ),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getInputDecoration(String label, Icon icon){

    if(label=="Password" || label=="Confirm Password"){
      return InputDecoration(
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
        labelText: label,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Colors.brown[900]
          ),
        ),
      );
    }else{
      return InputDecoration(
        labelStyle: TextStyle(
            color: Colors.brown[900]
        ),
        labelText: label,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Colors.brown[900]
          ),
        ),
      );
    }

  }
}
