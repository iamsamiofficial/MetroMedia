

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/AltProfile/alt_profile.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../services/Authentication.dart';
import '../../utils/PostOption.dart';
import '../LandingPage/landingPage.dart';

class ProfileHelpers with ChangeNotifier{
  ConstantColors constantColors = ConstantColors();
  Widget headerProfile(BuildContext context, snapshots){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      width: MediaQuery.of(context).size.width,
      child: Row(
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
                        onTap: (){
                          checkFollowerSheet(context,snapshots);
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
                        onTap: (){
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
                              .doc(Provider.of<Authentication>(context,listen: false).getUserUid)
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
                                            scrollDirection: Axis.horizontal,
                                            children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot) {
                                              if(snapshots.connectionState == ConnectionState.waiting){
                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }
                                              else{
                                                return Container(
                                                  height: 60.0,
                                                  width: 60.0,
                                                  color: constantColors.transperant,
                                                  child: CircleAvatar(
                                                    backgroundImage: NetworkImage((documentSnapshot.data as dynamic)['userimage'])),
                                                );
                                              }
                                            }).toList(),
                                          );
                                        }
                                      },
                                      ),
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget footerProfile(BuildContext context,snapshots){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
          .collection('users').doc(
            Provider.of<Authentication>(context,listen: false).getUserUid
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
                      showPostDetails(context,documentSnapshot);
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
  // Image.asset('assets/images/empty.png'),

  logOutDialog(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            'Logout MetroMedia?',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            ),
            actions: [
              MaterialButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    decoration: TextDecoration.underline,
                    decorationColor: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  ),
                
                ),
                MaterialButton(
                color: constantColors.redColor,
                onPressed: (){
                  Provider.of<Authentication>(context,listen: false).logOutViaEmail().whenComplete((){
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: Landingpage(),
                    type:PageTransitionType.bottomToTop),
                  );
              });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    decoration: TextDecoration.underline,
                    decorationColor: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  ),
                
                ),
            ],
        );
      });
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
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: AltProfile(
                                useruid: (documentSnapshot.data as dynamic)['useruid'],
                                ),
                              type: PageTransitionType.topToBottom),
                            );
                        },
                        trailing: MaterialButton(
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
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: AltProfile(
                                useruid: (documentSnapshot.data as dynamic)['useruid'],
                                ),
                              type: PageTransitionType.topToBottom),
                            );
                        },
                        trailing: MaterialButton(
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