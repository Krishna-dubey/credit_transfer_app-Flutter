import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credittransferapp/Services/AuthServices.dart';
import 'package:credittransferapp/Services/DatabaseServices.dart';
import 'package:credittransferapp/screens/Home/Models/ModelForUsers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class ProfileFragment extends StatefulWidget {

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {

  ProgressDialog progressDialog;

  FirebaseStorage _storage=FirebaseStorage(storageBucket: "gs://credit-transfer-app-321f1.appspot.com");

  Future startUpload(String filePath, File imageFile,String uid,BuildContext context)async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //connection available
        StorageUploadTask _uploadTask= await _storage.ref().child(filePath).putFile(imageFile);

        progressDialog= ProgressDialog(context,type: ProgressDialogType.Download,isDismissible: true);
        progressDialog.style(message:"Uploading Image...",progress:0.00,maxProgress: 100.00);
        if(!progressDialog.isShowing()){
          await progressDialog.show();
        }
        await _uploadTask.events.listen((event) async{
          double progressPercent= event!=null ? event.snapshot.bytesTransferred.toDouble()/event.snapshot.totalByteCount.toDouble() : 0;
          if(_uploadTask.isInProgress){
            print(progressPercent*100);
            progressDialog.update(progress: double.parse((progressPercent*100).toStringAsFixed(2)));
          }

          if(_uploadTask.isComplete){
            var downloadUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
            String imageUrl = downloadUrl.toString();
            print(imageUrl);
            DatabaseService(uid).updateUserProfileImage(imageUrl.toString());
            if(progressDialog.isShowing()){
              progressDialog.hide();
            }
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Upload Successful",toastLength: Toast.LENGTH_LONG);
          }

        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection",toastLength: Toast.LENGTH_LONG);
    }

  }
  @override
  Widget build(BuildContext context) {
    //get user profile data
    DocumentSnapshot profileDetails=Provider.of<DocumentSnapshot>(context);

    //if null then show loading by progress bar
    if(profileDetails == null) return Center(child: CircularProgressIndicator());

    //preapre user object
    User user = User(profileDetails.data['name'],profileDetails.data['gender'],profileDetails.data['email'],
      profileDetails.data['credits'],profileDetails.data['imageUrl'],profileDetails.data['uid']);

    File _imageFile;

    Future pickImage() async{
      File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile=selected;
      });
    }

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Center(
               child: Container(
                 height: 140,
                 child: Stack(
                   children: <Widget>[
                     CircleAvatar(
                       backgroundImage: NetworkImage(user.imageUrl),
                       radius: 60,
                     ),
                     Positioned(
                       bottom: 15,
                       right: 2,
                       child: SizedBox(
                         height: 40,
                         width: 40,
                         child: FloatingActionButton(
                           backgroundColor: Colors.brown[900],
                           onPressed: () async{
                             await pickImage();
                             if(_imageFile!=null){
                               showDialog(context: context,builder: (context){
                                 return Dialog(
                                   child: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     children: <Widget>[
                                       Container(
                                         margin: EdgeInsets.fromLTRB(20,20,20,0),
                                           child: Image.file(_imageFile)
                                       ),
                                       Container(
                                         margin: EdgeInsets.all(20),
                                         child: RaisedButton(
                                           onPressed: () async{
                                             await startUpload('profileImages/${user.uid}/${user.uid}.png',_imageFile,user.uid,context);
                                           },
                                           child: Text("Upload",style: TextStyle(color: Colors.white),),
                                           color: Colors.brown[900],
                                         ),
                                       )
                                     ],
                                   ),
                                 );
                               });
                             }

                           },
                           child: Icon(Icons.add),
                         ),
                       ),
                     )
                   ],
                 ),
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
                    onPressed: () async{
                     dynamic result= await AuthServices().signOut();
                     if(result!=null){
                       Fluttertoast.showToast(msg: result.toString(),toastLength: Toast.LENGTH_LONG);
                     }else{
                       Fluttertoast.showToast(msg: "Logout successful",toastLength: Toast.LENGTH_LONG);

                     }
                    },
                    icon: Icon(
                        Icons.settings_power,
                      color: Colors.white,
                    ),
                    label: Text(
                        "Logout",
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

