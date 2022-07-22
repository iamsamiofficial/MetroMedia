import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/AltProfile/alt_profile.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:metromedia/utils/PostOption.dart';
import 'package:metromedia/utils/UploadPost.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  PreferredSizeWidget appBar(BuildContext context){
    return AppBar(
      backgroundColor: constantColors.darkColor.withOpacity(0.6),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: (){
            Provider.of<UploadPost>(context,listen: false).selectPostImageType(context);
          },
          icon: Icon(
            Icons.camera_enhance_rounded,
            color: constantColors.greenColor,
            ),
          ),
      ],
      title: RichText(
          text: TextSpan(
            text: 'Metro ',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Feed',
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          ),
    );
  }

  Widget feedBody(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Container(
          
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').orderBy('time',descending: true) .snapshots(),
            builder: (context,snapshots){
              if(snapshots.connectionState == ConnectionState.waiting){
                return Center(
                  child: SizedBox(
                    height: 500.0,
                    width: 400.0,
                    child: Lottie.asset('assets/animations/loading.json'),
                  ),
                );
              }
              else{
                return loadPost(context,snapshots);
              }
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.6),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0),topRight: Radius.circular(18))
          ),
        ),
      ),
    );
  }

  Widget loadPost(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshots) {
    return ListView(
      shrinkWrap: true,
      children: snapshots.data!.docs.map((DocumentSnapshot documentSnapshot){
        Provider.of<PostFunctions>(context,listen: false).showTimeAgo(
          (documentSnapshot.data as dynamic)['time']
        );
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:8.0,left:8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        if(((documentSnapshot.data) as dynamic)['useruid'] != Provider.of<Authentication>(context,listen: false).getUserUid){
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: AltProfile(
                                useruid:((documentSnapshot.data) as dynamic)['useruid'],
                              ),
                              type: PageTransitionType.bottomToTop,
                              ),
                            );
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: constantColors.blueGreyColor,
                        radius: 20.0,
                        backgroundImage: NetworkImage((documentSnapshot.data  as dynamic)['userimage']),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:12.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                (documentSnapshot.data! as dynamic)['caption'],
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                                ),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                  text: (documentSnapshot.data! as dynamic)['username'],
                                  style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' , ${Provider.of<PostFunctions>(context,listen: false).getimageTimePosted.toString()}',
                                    style: TextStyle(
                                      color: constantColors.lightColor.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                                ),
                                ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.05,
                    //   width: MediaQuery.of(context).size.width * 0.25,
                      
                    //   child: StreamBuilder<QuerySnapshot>(
                    //     stream: FirebaseFirestore.instance.collection('posts')
                    //     .doc(
                    //       (documentSnapshot.data as dynamic)['caption']
                    //     ).collection('awards').snapshots(),
                    //     builder: (context,snapshots){
                    //       if(snapshots.connectionState == ConnectionState.waiting){
                    //         return Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       }
                    //       else{
                    //         return ListView(
                    //           scrollDirection: Axis.horizontal,
                    //           children: snapshots.data!.docs.map((DocumentSnapshot documentSnapshot){
                    //             return Container(
                    //               height: 30.0,
                    //               width: 30.0,
                    //               child: Image.network((documentSnapshot.data as dynamic)['award'],),
                    //             );
                    //           }).toList(),
                    //         );
                    //       }
                    //     },
                    //     ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.46,
                  width: MediaQuery.of(context).size.width,
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      (documentSnapshot.data! as dynamic)['postimage'],scale: 2,
                      fit: BoxFit.cover,
                      ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0,left: 20.0),
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
                              FontAwesomeIcons.share,
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
              ),
              
            ],
          ),
        );
      }).toList(),
    );
  }
}