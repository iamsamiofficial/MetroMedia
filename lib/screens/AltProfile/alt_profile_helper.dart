import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/AltProfile/alt_profile.dart';
import 'package:metromedia/screens/Homepage/Homepage.dart';
import 'package:metromedia/screens/Messaging/singleMessage.dart';
import 'package:metromedia/screens/Profile/Profile.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:metromedia/services/FirebaseOperations.dart';
import 'package:metromedia/utils/PostOption.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../Chatroom/singlechatroom.dart';

class AltProfileHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  //String value = 'Add';

  PreferredSizeWidget appBar(BuildContext context){
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        onPressed: (){
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: Homepage(),
              type: PageTransitionType.bottomToTop,
              ),
            );
        },
        icon: Icon(Icons.arrow_back_ios_rounded),
        color: constantColors.whiteColor,
        ),
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushReplacement(
                context,
                PageTransition(
                child: Homepage(),
                type: PageTransitionType.bottomToTop,
                ),
              );
           },
        icon: Icon(Icons.more_vert),
        color: constantColors.whiteColor,
        ),
        ],
        title: RichText(
          text: TextSpan(
            text: 'Metro',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Media',
                style: TextStyle(
                color: constantColors.blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                ),
              ),
            ]
          ),
        ),
    );
  }

  Widget headerProfile(BuildContext context, snapshots,String userUid){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.365,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 220.0,
                width: 180.0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){},
                      child: CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        radius: 60,
                        backgroundImage: NetworkImage((snapshots.data! as dynamic)['userimage'])
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Text(
                        (snapshots.data! as dynamic)['username'],
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ID:',style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize:12),),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text(
                              (snapshots.data! as dynamic)['usermetro'],
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 200.0,
               
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              checkFollowerSheet(context, snapshots);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: constantColors.darkColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 80.0,
                              width: 80.0,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('users')
                                    .doc((snapshots.data as dynamic)['useruid']).
                                    collection('followers').snapshots(),
                                    builder: (context,snapshots){
                                      if(snapshots.connectionState == ConnectionState.waiting){
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      else{
                                        return Text(
                                          (snapshots.data as dynamic).docs.length.toString(),
                                          style:TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28.0,
                                          ),
                                        );
                                      }
                                    },
                                    ),
                                     Text(
                                    'Followers',
                                    style:TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                    ),
                                  
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              checkFollowingSheet(context, snapshots);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: constantColors.darkColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 80.0,
                              width: 80.0,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('users')
                                    .doc((snapshots.data as dynamic)['useruid']).
                                    collection('following').snapshots(),
                                    builder: (context,snapshots){
                                      if(snapshots.connectionState == ConnectionState.waiting){
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      else{
                                        return Text(
                                          (snapshots.data as dynamic).docs.length.toString(),
                                          style:TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28.0,
                                          ),
                                        );
                                      }
                                    },
                                    ),
                                     Text(
                                    'Following',
                                    style:TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                    ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Container(
                            decoration: BoxDecoration(
                              color: constantColors.darkColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 80.0,
                            width: 80.0,
                            child: Column(
                              children: [
                                   StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('users')
                              .doc((snapshots.data as dynamic)['useruid'])
                              .collection('posts').snapshots(),
                              builder: (context,snapshots){
                                if(snapshots.connectionState == ConnectionState.waiting){
                                  return Center(child: CircularProgressIndicator(),);
                              }
                              else{
                                return Text(
                              (snapshots.data as dynamic).docs.length.toString(),
                              style:TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                              ),
                              );

                              }
                              }                           
                              ),
                                   Text(
                                  'Posts',
                                  style:TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                  ),
                                
                              ],
                            ),
                          ),
                    ),
                  ],
                  
                ),
              ),
            ],
            ),
          Container(
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width,
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: (){
                    Provider.of<FirebaseOperations>(context,listen: false).followUser(
                      userUid,
                      Provider.of<Authentication>(context,listen: false).getUserUid,
                      {
                        'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
                        'useremail':Provider.of<FirebaseOperations>(context,listen: false).getInitUserEmail,
                        'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
                        'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
                        'time':Timestamp.now(),
                      }, 
                      Provider.of<Authentication>(context,listen: false).getUserUid,
                      userUid, 
                      {
                        'username':(snapshots.data as dynamic)['username'],
                        'useremail':(snapshots.data as dynamic)['useremail'],
                        'userimage':(snapshots.data as dynamic)['userimage'],
                        'useruid':userUid,
                        'time':Timestamp.now(),
                      }
                      ).whenComplete((){
                        followedNotification(context,(snapshots.data as dynamic)['username']);
                        
                      });
                  },
                  color: constantColors.darkColor,
                  child: Icon(
                      
                      FontAwesomeIcons.plus,
        
                        color: constantColors.whiteColor,
                        size: 16.0,
                      
                      ),
                  // child: StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance.collection('users')
                  //   .doc((snapshots.data as dynamic)['useruid'])
                  //   .collection('followers').snapshots(),
                  //   builder: (context,snapshots){
                  //     if(snapshots.connectionState == ConnectionState.waiting){
                  //       return Center(child: CircularProgressIndicator(),);
                  //     }
                  //     else{
                  //       return SizedBox(
                  //         height: 50,
                  //         width: 60,
                  //         child: ListView(
                  //           shrinkWrap: true,
                  //           children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot) {
                  //             return (documentSnapshot.data as dynamic)['useruid'] == Provider.of<Authentication>(context,listen: false).getUserUid
                  //             ?Text(
                    
                  //   'Added',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: constantColors.whiteColor,
                  //     fontSize: 16.0,
                  //   ),
                  //   ):Padding(
                  //     padding: const EdgeInsets.only(top:8.0),
                  //     child: Icon(
                      
                  //     FontAwesomeIcons.plus,
        
                  //       color: constantColors.whiteColor,
                  //       size: 16.0,
                      
                  //     ),
                  //   );
                  //           }).toList(),
                  //         ),
                  //       );
                  //     }
                  //   },
                  // ),
                  
                  ),
                  MaterialButton(
                  onPressed: (){
                    Provider.of<FirebaseOperations>(context,listen: false).messageinformation(
                      (snapshots.data as dynamic)['useruid'],
                      
                      {
                        'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
                        'useremail':Provider.of<FirebaseOperations>(context,listen: false).getInitUserEmail,
                        'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
                        'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
                        'endname':(snapshots.data as dynamic)['username'],
                        'endemail':(snapshots.data as dynamic)['useremail'],
                        'endimage':(snapshots.data as dynamic)['userimage'],
                        'enduid':(snapshots.data as dynamic)['useruid'],
                        'time':Timestamp.now(),
                      }
                      ).whenComplete(() {
                        Provider.of<FirebaseOperations>(context,listen: false).messageinformation(
                          Provider.of<Authentication>(context,listen:false).getUserUid,
                      
                      
                      {
                        'username':(snapshots.data as dynamic)['username'],
                        'useremail':(snapshots.data as dynamic)['useremail'],
                        'userimage':(snapshots.data as dynamic)['userimage'],
                        'useruid':(snapshots.data as dynamic)['useruid'],
                        'endname':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
                        'endemail':Provider.of<FirebaseOperations>(context,listen: false).getInitUserEmail,
                        'endimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
                        'enduid':Provider.of<Authentication>(context,listen: false).getUserUid,
                        'time':Timestamp.now(),
                      });
                      }).whenComplete(() {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: SingleChatroom(),
                            type: PageTransitionType.bottomToTop),
                          );
                      });
                  },
                  color: constantColors.darkColor,
                  child: Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                    ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
   Widget divider(){
    return Center(
      child: SizedBox(
        height: 25.0,
        width: 350.0,
        child: Divider(
          color: constantColors.whiteColor),
      ),
      );
  }

  Widget middleProfile(BuildContext context,snapshots){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Container(
            width: 180.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(FontAwesomeIcons.userAstronaut,color: constantColors.yellowColor,size: 16,),
                Text(
                  'Recently Added',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: constantColors.whiteColor,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget footerProfile(BuildContext context,snapshots){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
          .collection('users').doc(
            (snapshots.data as dynamic)['useruid']
          ).collection('posts').snapshots(),
          builder: (context,snapshots){
            if(snapshots.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else{
              return GridView(
                
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  ),
                children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot) {
                  return GestureDetector(
                    onTap: (){
                      showPostDetails(context, documentSnapshot);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          child: Image.network((documentSnapshot.data as dynamic)['postimage']),
                        ),
                      ),
                    ),
                  );
                }).toList(),

                );
            }
          }),
        height: MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(5.0)
        ),
      ),
    );
  }

  followedNotification(BuildContext context,String name){
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Text(
                  'Added $name',
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  ),
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
      );
  }

  checkFollowingSheet(BuildContext context,snapshots){
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users')
            .doc((snapshots.data as dynamic)['useruid']).
            collection('following').snapshots(),
            builder: (context,snapshots){
              if(snapshots.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                  );
              }
              else{
                return ListView(
                  children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot) {
                    if(snapshots.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else{
                      return ListTile(
                        onTap: () {
                          if((documentSnapshot.data as dynamic)['useruid'] != Provider.of<Authentication>(context,listen:false).getUserUid){
                            Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: AltProfile(
                                useruid: (documentSnapshot.data as dynamic)['useruid'],
                                ),
                              type: PageTransitionType.topToBottom),
                            );
                          }
                          
                        },
                        trailing:(documentSnapshot.data as dynamic)['useruid'] == Provider.of<Authentication>(context,listen:false).getUserUid
                        ? Container(height: 0.0,width: 0.0,)
                        : MaterialButton(
                          onPressed: (){},
                          color: constantColors.blueColor,
                          child: Text(
                            'Unfollow',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0
                            ),
                            ),
                          ),
                        leading: CircleAvatar(
                          backgroundColor: constantColors.darkColor,
                          backgroundImage: NetworkImage(
                            (documentSnapshot.data as dynamic)['userimage'],
                          ),
                        ),
                        title: Text(
                          (documentSnapshot.data as dynamic)['username'],
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        subtitle: Text(
                          (documentSnapshot.data as dynamic)['useremail'],
                          style: TextStyle(
                            color: constantColors.yellowColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      );
                    }
                  }).toList(),
                );
              }
            },
          ),
        );
      },
      );
  }

  checkFollowerSheet(BuildContext context,snapshots){
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users')
            .doc((snapshots.data as dynamic)['useruid']).
            collection('followers').snapshots(),
            builder: (context,snapshots){
              if(snapshots.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                  );
              }
              else{
                return ListView(
                  children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot) {
                    if(snapshots.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else{
                      return ListTile(
                        onTap: (){
                          if((documentSnapshot.data as dynamic)['useruid'] != Provider.of<Authentication>(context,listen:false).getUserUid){
                            Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: AltProfile(
                                useruid: (documentSnapshot.data as dynamic)['useruid'],
                                ),
                              type: PageTransitionType.topToBottom),
                            );
                          }
                        },
                        trailing: (documentSnapshot.data as dynamic)['useruid'] == Provider.of<Authentication>(context,listen:false).getUserUid
                        ? Container(height: 0.0,width: 0.0,)
                        : MaterialButton(
                          onPressed: (){},
                          color: constantColors.blueColor,
                          child: Text(
                            'Follow',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0
                            ),
                            ),
                          ),
                        leading: CircleAvatar(
                          backgroundColor: constantColors.darkColor,
                          backgroundImage: NetworkImage(
                            (documentSnapshot.data as dynamic)['userimage'],
                          ),
                        ),
                        title: Text(
                          (documentSnapshot.data as dynamic)['username'],
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        subtitle: Text(
                          (documentSnapshot.data as dynamic)['useremail'],
                          style: TextStyle(
                            color: constantColors.yellowColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      );
                    }
                  }).toList(),
                );
              }
            },
          ),
        );
      },
      );
  }

  showPostDetails(BuildContext context,DocumentSnapshot documentSnapshot){
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Image.network(
                    (documentSnapshot.data as dynamic)['postimage'])
                  ),
              ),
              Text(
                (documentSnapshot.data as dynamic)['caption'],
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight:FontWeight.bold,
                  fontSize: 16.0
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 80.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onLongPress: (){
                              Provider.of<PostFunctions>(context,listen: false).showLikes(
                                context,
                                (documentSnapshot.data as dynamic)['caption'],
                                );
                            },
                            onTap: (){
                              print('adding like...');
                              Provider.of<PostFunctions>(context,listen: false)
                              .addLike(
                                context,
                                (documentSnapshot.data as dynamic)['caption'],
                                Provider.of<Authentication>(context,listen: false).getUserUid,
                                );
                            },
                            child: Icon(
                              FontAwesomeIcons.heart,
                              color: constantColors.redColor,
                              size: 22.0,
                              ),
                          ),
                         StreamBuilder<QuerySnapshot>(
                           stream: FirebaseFirestore.instance.collection('posts').
                           doc((documentSnapshot.data as dynamic)['caption']).
                           collection('likes').snapshots(),
                           builder: (context,snapshots){
                             if(snapshots.connectionState == ConnectionState.waiting){
                               return Center(
                                 child: CircularProgressIndicator(),
                               );
                             }
                             else{
                               return Padding(
                                 padding: const EdgeInsets.only(left:8.0),
                                 child: Text(
                                   (snapshots.data as dynamic).docs.length.toString(),
                                   style: TextStyle(
                                     color: constantColors.whiteColor,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 18.0,
                                     ),
                                  ),
                                );
                             }
                           }),
                        ],
                      ),
                    ),
                    Container(
                      width: 80.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Provider.of<PostFunctions>(context,listen: false)
                              .showCommentsSheet(
                                context,
                                documentSnapshot,
                                (documentSnapshot.data as dynamic)['caption'],
                                );
                            },
                            child: Icon(
                              FontAwesomeIcons.comment,
                              color: constantColors.blueColor,
                              size: 22.0,
                              ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                           stream: FirebaseFirestore.instance.collection('posts').
                           doc((documentSnapshot.data as dynamic)['caption']).
                           collection('comments').snapshots(),
                           builder: (context,snapshots){
                             if(snapshots.connectionState == ConnectionState.waiting){
                               return Center(
                                 child: CircularProgressIndicator(),
                               );
                             }
                             else{
                               return Padding(
                                 padding: const EdgeInsets.only(left:8.0),
                                 child: Text(
                                   (snapshots.data as dynamic).docs.length.toString(),
                                   style: TextStyle(
                                     color: constantColors.whiteColor,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 18.0,
                                     ),
                                  ),
                                );
                             }
                           }),
                        ],
                      ),
                    ),
                    Container(
                      width: 80.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            // onLongPress: Provider.of<PostFunctions>(context,listen: false).showAwardPresenter(
                            //   context,
                            //   (documentSnapshot.data! as dynamic)['caption']),
                            onTap: (){
                              Provider.of<PostFunctions>(context,listen: false).showRewards(
                                context,
                                (documentSnapshot.data! as dynamic)['caption'],
                                );
                            },
                            child: Icon(
                              FontAwesomeIcons.award,
                              color: constantColors.yellowColor,
                              size: 22.0,
                              ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                           stream: FirebaseFirestore.instance.collection('posts').
                           doc((documentSnapshot.data as dynamic)['caption']).
                           collection('awards').snapshots(),
                           builder: (context,snapshots){
                             if(snapshots.connectionState == ConnectionState.waiting){
                               return Center(
                                 child: CircularProgressIndicator(),
                               );
                             }
                             else{
                               return Padding(
                                 padding: const EdgeInsets.only(left:8.0),
                                 child: Text(
                                   (snapshots.data as dynamic).docs.length.toString(),
                                   style: TextStyle(
                                     color: constantColors.whiteColor,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 18.0,
                                     ),
                                  ),
                                );
                             }
                           }),
                        ],
                      ),
                    ),
                    Spacer(),
                    Provider.of<Authentication>(context,listen: false).getUserUid == (documentSnapshot.data! as dynamic)!['useruid']?IconButton(
                      onPressed: (){
                        Provider.of<PostFunctions>(context,listen: false).
                        showPostOptions(
                          context,
                          (documentSnapshot.data as dynamic)['caption']
                          );
                      }, icon: Icon(Icons.more_vert,color: constantColors.whiteColor,),):
                      Container(height: 0,width: 0,),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}