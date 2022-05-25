
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:metro_media/models/user.dart' as model;
import 'package:metro_media/resources/storage_methods.dart';
import 'package:metro_media/utils/utils.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection("members").doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String>signupUser(
    {
      required  String email,
      required String password,
      required String bio,
      required String username,
      required Uint8List file,
    }
  ) async {
    String res = 'an error occurred';
    try {
      if(email.isNotEmpty || password.isNotEmpty || bio.isNotEmpty || username.isNotEmpty || file != null){
       UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
       print(cred.user!.uid);
       
       //storing picture in storage
       String photoUrl = await StorageMethods().uploadImage('profilePics', file, false);

       //storing info in firestore with doc
       model.User user = model.User(
         email: email,
         uid: cred.user!.uid,
         bio: bio,
         username: username,
         password: password,
         followers: [],
         following: [],
         photoUrl: photoUrl,
       );

       await _firestore.collection('members').doc(cred.user!.uid).set(user.toJson(),);
       
       //storing info in firestore without doc
      //  await _firestore.collection("collectionPath").add({
      //    'email':email,
      //    'password': password,
      //    'bio': bio,
      //    'username':username,
      //    //'photoUrl':photoUrl,
      //  }
      //  );
      res = 'success';
      }
     
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //For login part
  Future<String> loginUser(
    {
      required String email,
      required String password,
    }
  ) async {
    String res = 'an error occured';
    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'Success';
        
      }else{
        res = 'Please enter all the fields';
      }

    }catch(err){
      res = err.toString();
    }
    return res;
  }
}