import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credittransferapp/Services/DatabaseServices.dart';
import 'package:credittransferapp/screens/Home/Models/ModelForUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices{
  FirebaseAuth _auth=FirebaseAuth.instance;



  Stream<FirebaseUser> get user{
    return _auth.onAuthStateChanged;
  }

  //Register with email and password
  Future registerWithEmailAndPassword(String email,String password,String gender,String name,String imageUrl) async{
    try{
      AuthResult result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String uid=result.user.uid;
      await DatabaseService(uid).addUsers(User(name,gender,email,"1000",imageUrl,uid));
    }catch(e){
      return e.message;
    }

  }

    //sign in with email and password
  Future signInWithEmailAndPassword(String email,String password) async{
    String errorMessage;
    try{
      dynamic result=await _auth.signInWithEmailAndPassword(email: email, password: password);
//      return result;
    }catch(e){
      return e.message;
    }
  }

  //Forgot Password
  Future resetPassword(String email)async{
    try{
     await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      return e.message;
    }
  }


  //Sign out
    Future signOut() async{
      try{
        await _auth.signOut();
      }catch(e){
        return e.message;
      }
    }
}