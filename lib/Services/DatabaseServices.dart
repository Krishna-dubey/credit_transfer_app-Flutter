import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credittransferapp/Services/AuthServices.dart';
import 'package:credittransferapp/screens/Home/Models/ModelForUsers.dart';
import 'package:credittransferapp/screens/Transaction/ModelForTransaction.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService{
  String uid;

  CollectionReference user_collection=Firestore.instance.collection("users");
  CollectionReference transaction_collection=Firestore.instance.collection("transactions");

  DatabaseService(this.uid);

  Future addUsers(User user) async{
    try{
       await user_collection.document(user.uid).setData({
        "name":user.name,
        "email":user.email,
        "gender":user.gender,
        "credits":user.credits,
        "imageUrl":user.imageUrl,
        "uid":user.uid
      });
    }catch(e){
      return e;
    }
  }
  
  //update user credits
  Future updateUserCredit(String newCredits) async{
    try{
       Firestore.instance.runTransaction((Transaction transaction)async{
        await transaction.update(user_collection.document(uid), {
          "credits":newCredits
        });
      });
    }catch(e){
      return e;
    }
  }

  //update user ProfileImage
  Future updateUserProfileImage(String imageUrl) async{
    try{
        await user_collection.document(uid).updateData({"imageUrl":imageUrl});
    }catch(e){
      return e;
    }
  }

  //add to transaction
  Future storeTransaction(ModelForTransaction transactionData) async{
    try{
      await transaction_collection.document(uid).collection(uid).add({
        "uid":transactionData.uid,
        "type":transactionData.type,
        "name":transactionData.name,
        "credits":transactionData.credits,
        "dateAndTime":transactionData.dateAndTime,
      });
//          .document().setData();
    }catch(e){
      return e;
    }
  }

  //get transactions
  Stream<QuerySnapshot> get transaction{
    return transaction_collection.document(uid).collection(uid).orderBy("dateAndTime",descending: true).snapshots();
  }

  //List of users
  Stream<QuerySnapshot> get users{
    return user_collection.snapshots();
  }


//  Current user profile data
  Stream<DocumentSnapshot> get userProfile {
    return user_collection.document(uid).snapshots();
  }

}