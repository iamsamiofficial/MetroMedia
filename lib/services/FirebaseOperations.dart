import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:provider/provider.dart';

import '../screens/LandingPage/landingUtils.dart';

class FirebaseOperations with ChangeNotifier{
  UploadTask? imageUploadTask;
  String initUserEmail = '', initUserName = '', initUserImage ='';
  String get getInitUserEmail => initUserEmail;
  String get getInitUserName => initUserName;
  String get getInitUserImage => initUserImage;

  Future uploadUserAvatar(BuildContext context) async{
    Reference imageReference = FirebaseStorage.instance.ref().child(
      'userProfileAvatar/${Provider.of<LandingUtils>(context,listen:false).getUserAvatar.path}/${TimeOfDay.now()}'

    );
    imageUploadTask = imageReference.putFile(Provider.of<LandingUtils>(context,listen:false).getUserAvatar);

    await imageUploadTask!.whenComplete(() {
      print("Image Uploaded!");
    });
    imageReference.getDownloadURL().then((url){
      Provider.of<LandingUtils>(context,listen: false).userAvatarUrl = url.toString();
      print('The use profile avatar url => ${Provider.of<LandingUtils>(context,listen: false).userAvatarUrl}');
      notifyListeners();
    });
    
  }
  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance.collection('users').doc(Provider.of<Authentication>(context,listen: false).userUid).set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance.collection('users').doc(Provider.of<Authentication>(
      context,listen: false).userUid).get().then((doc) {
        print('fetch user data');
        initUserName = (doc.data as dynamic)['username'];
        initUserEmail = (doc.data as dynamic)['useremail'];
        initUserImage = (doc.data as dynamic)['userimage'];
        print(initUserName);
        print(initUserEmail);
        print(initUserImage);
        notifyListeners();
      });
  }



  Future uploadPostData(String postId,dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(
      postId
    ).set(data);

  }

  Future deleteUserData(String userUid, dynamic collection){
    return FirebaseFirestore.instance.collection(collection).doc(userUid).delete();
  }
  Future deleteUserDataFromUser(String uid,String userUid,dynamic collectionuser, dynamic collection){
    return FirebaseFirestore.instance.collection(collectionuser).doc(uid)
    .collection(collection).doc(userUid).delete();
  }
  Future addAward(String postId,dynamic data) async{
    return FirebaseFirestore.instance.collection('posts').doc(postId).collection('awards').add(data);
  }
  Future updateCaption(String postId,dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).update(data);
  }

  Future followUser(
    String followingUid,
    String followingDocId,
    dynamic followingData,
    String followerUid,
    String followerDocId,
    dynamic followerData) async {
      return FirebaseFirestore.instance.collection('users').
      doc(followingUid).collection('followers').doc(followingDocId)
      .set(followingData).whenComplete(() async {
        FirebaseFirestore.instance.collection('users')
        .doc(followerUid).collection('following').doc(followerDocId)
        .set(followerData);
      });

  }

  Future submitChatroomData(String chatRoomName,dynamic chatRoomData) async {
    return FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomName)
    .set(chatRoomData);
  }


    Future messageinformation(
    String endid,
    dynamic ourdata) async {
      return FirebaseFirestore.instance.collection('userchatroom').
      doc(endid).set(ourdata);

  }
}