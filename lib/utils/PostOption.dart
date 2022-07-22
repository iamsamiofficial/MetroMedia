import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/AltProfile/alt_profile.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:metromedia/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier{
  TextEditingController commentController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  String? imageTimePosted;
  String? get getimageTimePosted => imageTimePosted;
  TextEditingController updatedCaptionController = TextEditingController();

  showTimeAgo(dynamic timeData){
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    notifyListeners();
  }
   showPostOptions(BuildContext context,String postId){
     return showModalBottomSheet(
       isScrollControlled: true,
       context: context,
       builder: (context){
         return Padding(
           padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
           child: Container(
             child: Column(
               children: [
                 Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150.0),
                      child: Divider(
                        thickness: 4.0,
                        color: constantColors.whiteColor,
                      ),
                    ),
                 Container(
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       MaterialButton(
                         color: constantColors.blueColor,
                         onPressed: (){
                           showModalBottomSheet(
                             context: context,
                             builder: (context){
                               return Container(
                                 child: Center(
                                   child:Row(
                                     children: [
                                       Container(
                                         width: 300.0,
                                         height: 50.0,
                                         child: TextField(
                                           decoration: InputDecoration(
                                             hintText: 'Add new caption',
                                             hintStyle: TextStyle(
                                               color:constantColors.whiteColor,
                                               fontWeight: FontWeight.bold,
                                               fontSize: 16.0,
                                             ),
                                           ),
                                           style: TextStyle(
                                             color:constantColors.whiteColor,
                                               fontWeight: FontWeight.bold,
                                               fontSize: 16.0,
                                           ),
                                           controller: updatedCaptionController,
                                         ),
                                         
                                       ),
                                       FloatingActionButton(
                                         backgroundColor: constantColors.redColor,
                                         child: Icon(FontAwesomeIcons.fileUpload),
                                         onPressed: (){
                                           Provider.of<FirebaseOperations>(context,listen: false).
                                           updateCaption(
                                             postId,
                                             {
                                               'caption':updatedCaptionController.text,
                                             },
                                             ).whenComplete((){
                                               Navigator.pop(context);
                                             });
                                         },

                                         ),
                                     ],
                                   )
                                 ),
                               );
                             },
                             );
                         },
                         child: Text(
                           'Edit Caption',
                           style: TextStyle(
                             color: constantColors.whiteColor,
                             fontWeight: FontWeight.bold,
                             fontSize: 16.0,
                           ),
                           ),
                         ),
                         MaterialButton(
                         color: constantColors.redColor,
                         onPressed: (){
                           showDialog(
                             context: context,
                             builder: (context){
                               return AlertDialog(
                                 backgroundColor: constantColors.blueGreyColor,
                                 title: Text(
                                   'Delete The Post?',
                                   style: TextStyle(
                                     color: constantColors.whiteColor,
                                     fontSize: 16.0,
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
                                         decoration: TextDecoration.underline,
                                         decorationColor: constantColors.whiteColor,
                                         color: constantColors.whiteColor,
                                         fontWeight: FontWeight.bold,
                                         fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                     color: constantColors.redColor,
                                     onPressed: (){
                                        Provider.of<FirebaseOperations>(context,listen: false).deleteUserData(
                                          postId,'posts',
                                          ).whenComplete((){
                                            Provider.of<FirebaseOperations>(context,listen: false).deleteUserDataFromUser(
                                              Provider.of<Authentication>(context,listen: false).getUserUid,
                                              postId,'users','posts');
                                          }).whenComplete((){
                                            Navigator.pop(context);
                                          });
                                     },
                                     child: Text(
                                       'Yes',
                                       style: TextStyle(
                                         decoration: TextDecoration.underline,
                                         decorationColor: constantColors.whiteColor,
                                         color: constantColors.whiteColor,
                                         fontWeight: FontWeight.bold,
                                         fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                 ],
                               );
                             });
                         },
                         child: Text(
                           'Delete Post',
                           style: TextStyle(
                             color: constantColors.whiteColor,
                             fontWeight: FontWeight.bold,
                             fontSize: 16.0,
                           ),
                           ),
                         ),
                     ],
                   ),
                 ),              
               ],
             ),
             height: MediaQuery.of(context).size.height * 0.1,
             width: MediaQuery.of(context).size.width,
             decoration: BoxDecoration(
               color: constantColors.blueGreyColor,
               borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(12,),
                 topRight: Radius.circular(12),
               ),
             ),
           ),
         );
       },
       );
   }

  Future addLike(BuildContext context,String postId,String subDocId) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).collection(
      'likes'
    ).doc(subDocId).set({
      'likes':FieldValue.increment(1),
      'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
      'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
      'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
      'useremail':Provider.of<FirebaseOperations>(context,listen: false).getInitUserEmail,
      'time':Timestamp.now(),
    });
  }

  Future addComment(BuildContext context,String postId,String comment) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId)
    .collection('comments')
    .doc(comment)
    .set({
      
      'comment':comment,
      'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
      'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
      'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
      'useremail':Provider.of<FirebaseOperations>(context,listen: false).getInitUserEmail,
      'time':Timestamp.now(),
    });
  }

  showAwardPresenter(BuildContext context,String postId){
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
              Container(
                    width: 125.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Rewards',
                        style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ), 
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('posts')
                      .doc(postId)
                      .collection('awards')
                      .orderBy('time')
                      .snapshots(),
                      builder: (context,snapshots){
                        if(snapshots.connectionState == ConnectionState.waiting){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else{
                          return ListView(
                            children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot){
                              return ListTile(
                                leading: GestureDetector(
                                  onTap: (){
                                    Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        child: AltProfile(
                                          useruid: (documentSnapshot.data as dynamic)['useruid']),
                                        type: PageTransitionType.bottomToTop,
                                        ),
                                      );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      (documentSnapshot.data as dynamic)['userimage'],
                                    ),
                                    radius: 15,
                                    backgroundColor: constantColors.darkColor,
                                  ),
                                ),
                                subtitle: Text(
                                  (documentSnapshot.data as dynamic)['useemail'],
                                  style: TextStyle(
                                    color:constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                title: Text(
                                  (documentSnapshot.data as dynamic)['username'],
                                  style: TextStyle(
                                    color:constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                trailing:Provider.of<Authentication>(context,listen: false).getUserUid == (documentSnapshot.data as dynamic)['useruid']?
                                  Container(height: 0,width: 0,):
                                   MaterialButton(
                                    onPressed: (){},
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        ),
                                        ),
                                    color: constantColors.blueColor,
                                    ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),              
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
        );
      },
      );
  }

  showCommentsSheet(BuildContext context,DocumentSnapshot snapshots,String docId){
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context){
        return Padding(
          
          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 125.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Comments',
                        style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.43,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('posts')
                      .doc(docId)
                      .collection('comments')
                      .orderBy('time')
                      .snapshots(),
                      builder: (context,snapshots){
                        if(snapshots.connectionState == ConnectionState.waiting){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else{
                          return ListView(
                            children: snapshots.data!.docs.map((DocumentSnapshot documentSnapshot){
                              return Container(
                                height: MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0,),
                                          child: GestureDetector(
                                            onTap: (){
                                               Navigator.pushReplacement(
                                                 context,
                                                 PageTransition(
                                                   child: AltProfile(
                                                     useruid: (documentSnapshot.data as dynamic)['useruid']),
                                                     type: PageTransitionType.bottomToTop,
                                                     ),
                                                    );
                                                  },
                                            child:CircleAvatar(
                                              backgroundColor: constantColors.darkColor,
                                              radius: 15.0,
                                             backgroundImage: NetworkImage(
                                               (documentSnapshot.data as dynamic)['userimage'],
                                             ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0),
                                          child: Container(
                                            child: Text((documentSnapshot.data as dynamic)['username'],
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight:FontWeight.bold,
                                              fontSize: 18.0
                                            ),),
                                          ),
                                        ),
                                        // Container(
                                        //   child: Row(
                                        //     children: [
                                        //       IconButton(
                                        //         onPressed: (){},
                                        //         icon: Icon(FontAwesomeIcons.arrowUp,
                                        //         color: constantColors.blueColor,
                                        //         size: 12,),
                                        //         ),
                                        //         Text(
                                        //           '0',
                                        //           style: TextStyle(
                                        //             color: constantColors.whiteColor,
                                        //             fontWeight: FontWeight.bold,
                                        //             fontSize: 14.0
                                        //           ),
                                        //           ),
                                        //         IconButton(
                                        //         onPressed: (){},
                                        //         icon: Icon(FontAwesomeIcons.reply,
                                        //         color: constantColors.yellowColor,
                                        //         size: 12,),
                                        //         ),
                                               
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: (){},
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: constantColors.blueColor,
                                              size: 12,
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.75,
                                              child: Text(
                                                (documentSnapshot.data as dynamic)['comment'],
                                                style: TextStyle(
                                                  color: constantColors.whiteColor,
                                                  fontSize: 16.0
                                                ),
                                              ),
                                            ),
                                             IconButton(
                                                onPressed: (){},
                                                icon: Icon(FontAwesomeIcons.trashAlt,
                                                color: constantColors.redColor,
                                                size: 16,),
                                                ),
                                        ],
                                      ),
                                    ),

                                    
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    
                    width: 400.0,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 300.0,
                          height: 50.0,
                          child: TextField(
                            controller: commentController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: constantColors.greenColor,
                          onPressed: (){
                            print('comment storing...');
                            addComment(
                              context,
                              (snapshots.data as dynamic)['caption'],
                              commentController.text,
                              ).whenComplete((){
                                commentController.clear();
                                notifyListeners();
                              });
                          },
                          child:Icon(
                            FontAwesomeIcons.comment,
                            color: constantColors.whiteColor,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
          ),
        );
      },
    );
  }

  showLikes(BuildContext context,String postId){
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          child: Column(
            children: [
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 100.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Likes',
                        style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 400,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('posts')
                      .doc(postId).collection('likes').snapshots(),
                      builder: (context,snapshots){
                        if(snapshots.connectionState == ConnectionState.waiting){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else{
                          return ListView(
                            children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot){
                              return ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        child: AltProfile(
                                          useruid: (documentSnapshot.data as dynamic)['useruid']),
                                        type: PageTransitionType.bottomToTop,
                                        ),
                                      );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      (documentSnapshot.data as dynamic)['userimage'],
                                    ),
                                  ),
                                ),
                                title: Text(
                                  (documentSnapshot.data as dynamic)['username'],
                                  style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                  ),
                                  subtitle: Text(
                                  (documentSnapshot.data as dynamic)['useremail'],
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                  ),
                                  // trailing:Provider.of<Authentication>(context,listen: false).getUserUid == (documentSnapshot.data as dynamic)['useruid']?
                                  // Container(height: 0,width: 0,):
                                  //  MaterialButton(
                                  //   onPressed: (){},
                                  //   child: Text(
                                  //     'Follow',
                                  //     style: TextStyle(
                                  //       color: constantColors.whiteColor,
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 14.0,
                                  //       ),
                                  //       ),
                                  //   color: constantColors.blueColor,
                                  //   ),
                              );
                            }).toList(),
                          );
                        }
                      },
                  ),
                  ),
            ],
          
          ),
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
        );
      }
      );
  }

  showRewards(BuildContext context,String postId){
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          child: Column(
            children: [
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 100.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Rewards',
                        style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('awards').snapshots(),
                        builder: (context,snapshots){
                          if(snapshots.connectionState == ConnectionState.waiting){
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          else{
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: (snapshots.data! as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot){
                                return GestureDetector(
                                  onTap: ()async{
                                    await Provider.of<FirebaseOperations>(context,listen: false).
                                    addAward(
                                      postId,
                                      {
                                        'username':Provider.of<FirebaseOperations>(context).getInitUserName,
                                        'userimage':Provider.of<FirebaseOperations>(context).getInitUserImage,
                                        'useruid':Provider.of<Authentication>(context).getUserUid,
                                        'time':Timestamp.now(),
                                        'award':(documentSnapshot.data as dynamic)['image'],
                                      }
                                      );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: Container(
                                      height:50.0,
                                      width: 50.0,
                                      child: Image.network((documentSnapshot.data as dynamic)['image']),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }),
                    ),
                  ),

            ],
          ),
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
        );
      }
      );
  }

}