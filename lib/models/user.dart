
import 'package:cloud_firestore/cloud_firestore.dart';

class User{

  final String email;
  final String uid;
  final String bio;
  final String username;
  final String password;
  final List followers;
  final List following;
  final String photoUrl;
  

  const User({
    required this.email,
    required this.uid,
    required this.bio,
    required this.username,
    required this.password,
    required this.followers,
    required this.following,
    required this.photoUrl,
    
  });

  Map<String,dynamic> toJson() => {
    'email':email,
    'uid': uid,
    'bio': bio,
    'username':username,
    'password':password,
    'followers':followers,
    'following': following,
    'photoUrl':photoUrl,
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'], 
      uid: snapshot['uid'], 
      bio: snapshot['bio'], 
      username: snapshot['username'],
      password: snapshot['password'],
      followers: snapshot['followers'], 
      following: snapshot['following'], 
      photoUrl: snapshot['photoUrl'], 
      
      );
  }
  
}