import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/AltProfile/alt_profile.dart';
import 'package:metromedia/screens/Messaging/groupMessage.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:metromedia/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatroomHelper with ChangeNotifier{
  late String latestmessagetime;
  String get getlatestmessagetime => latestmessagetime;
  String ? chatroomAvatarUrl,chatroomID;
  String ? get getchatroomID => chatroomID;
  String ? get getchatroomAvatarUrl => chatroomAvatarUrl;
  TextEditingController chatroomNameController = TextEditingController();
  ConstantColors constantColors = ConstantColors();

  showChatroomDetails(BuildContext context,DocumentSnapshot documentSnapshot){
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
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
                decoration: BoxDecoration(
                  border: Border.all(color: constantColors.blueColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Members',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('chatrooms')
                  .doc(documentSnapshot.id)
                  .collection('members')
                  .snapshots(),
                  builder: (context,snapshots){
                    if(snapshots.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else{
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot){
                          return Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: GestureDetector(
                              onTap: (){
                                if(Provider.of<Authentication>(context,listen: false).getUserUid
                                != (documentSnapshot.data as dynamic)['useruid']){
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      child: AltProfile(useruid:(documentSnapshot.data as dynamic)['useruid']), 
                                      type: PageTransitionType.bottomToTop),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: constantColors.darkColor,
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  (documentSnapshot.data as dynamic)['userimage']
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
        
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width,
              ),
               Container(
                decoration: BoxDecoration(
                  border: Border.all(color: constantColors.yellowColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Admin',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: constantColors.transperant,
                      backgroundImage: NetworkImage((documentSnapshot.data as dynamic)['userimage']),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text(
                            (documentSnapshot.data as dynamic)['username'],
                            style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                  ),
                            ),
                        
                        ),
                        Provider.of<Authentication>(context,listen: false).getUserUid == (documentSnapshot.data as dynamic)['useruid']
                        ?Padding(
                          padding: const EdgeInsets.only(left:16.0),
                          child: MaterialButton(
                            color: constantColors.redColor,
                            child: Text(
                              'Delete Group',
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            onPressed: (){
                              
                               showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    backgroundColor: constantColors.darkColor,
                                    title: Text(
                                      'Delete ChatRoom?',
                                      style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight:FontWeight.bold,
                                             fontSize: 16.0,
                                              ),

                                    ),
                                    actions: [
                                      MaterialButton(
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight:FontWeight.bold,
                                            fontSize: 14.0,
                                            decoration: TextDecoration.underline,
                                            decorationColor: constantColors.whiteColor,
                                          ),
                                        ),
                                        onPressed: (){
                                           Navigator.pop(context);
                                        }),
                                      MaterialButton(
                                        color: constantColors.redColor,
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight:FontWeight.bold,
                                             fontSize: 14.0,
                                              ),
                                              ),
                                         onPressed: (){
                                           FirebaseFirestore.instance
                                           .collection('chatrooms')
                                           .doc(documentSnapshot.id).delete()
                                           .whenComplete(() {
                                             Navigator.pop(context);
                                           });
                                           }),
                                      ],
                                    );
                                });
                              
                            }),
                        ):Container(height: 0.0,width: 0.0,),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),

        );
      },
    );
  }
  showCreateChatroomSheet(BuildContext context){
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
                Text(
                  'Select Chatroom Avatar',
                  style: TextStyle(
                    color: constantColors.greenColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                  ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('chatroomIcons').snapshots(),
                    builder: (context,snapshots){
                      if(snapshots.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      }
                      else{
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot){
                            return GestureDetector(
                              onTap: (){
                                chatroomAvatarUrl = (documentSnapshot.data as dynamic)['image'];
                                print(chatroomAvatarUrl);
                                notifyListeners();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left:16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: chatroomAvatarUrl == (documentSnapshot.data as dynamic)['image']
                                      ? constantColors.blueColor
                                      : constantColors.transperant
                                    )
                                  ),
                                  height: 10.0,
                                  width: 40.0,
                                  child: Image.network((documentSnapshot.data as dynamic)['image']),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller:chatroomNameController ,
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                        ),
                      decoration: InputDecoration(
                        hintText: 'Enter Chatroom Name',
                        hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: constantColors.blueGreyColor,
                      child: Icon(FontAwesomeIcons.plus,
                      color: constantColors.yellowColor,
                      ),
                      onPressed: ()async{
                        Provider.of<FirebaseOperations>(context,listen: false).submitChatroomData(
                          chatroomNameController.text,
                          {
                            'roomavatar':getchatroomAvatarUrl,
                            'time':Timestamp.now(),
                            'roomname':chatroomNameController.text,
                            'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
                            'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
                            'useremail':Provider.of<FirebaseOperations>(context,listen: false).getInitUserEmail,
                            'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
                          }
                         ).whenComplete(() {
                           Navigator.pop(context);
                         });
                      })
                  ],
                ),
              ],
            ),
            height:MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
        );
      },
      );
  }

  showChatrooms(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
      builder: (context,snapshots){
        if(snapshots.connectionState == ConnectionState.waiting){
          return Center(
            child: SizedBox(
              height: 200.0,
              width: 200.0,
              child: Lottie.asset('assets/animations/loading.json'),
            ),
          );
        }
        else{
          return ListView(
            children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot){
             
              return ListTile(
                onLongPress: (){
                  showChatroomDetails(context, documentSnapshot);
                },
                onTap: (){
                  Navigator.of(context).pushReplacement(
                    PageTransition(
                      child: GroupMessage(documentSnapshot:documentSnapshot),
                      type: PageTransitionType.bottomToTop),
                      );
                },
                title: Text(
                  (documentSnapshot.data as dynamic)['roomname'],
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0
                  ),
                  ),
                  trailing: Container(
                    width: 0,
                    child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('chatrooms')
                  .doc(documentSnapshot.id).collection('messages')
                  .orderBy('time',descending: true).snapshots(),
                  builder: (context,snapshots){
                     showLastMessageTime((snapshots.data as dynamic).docs.first.data['time']);
                    if(snapshots.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),); 
                    }
                    else{
                      return Text(
                    getlatestmessagetime,
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                    );
                    }
                  },
                 
                  ),
                  ),
                  // subtitle: Text(
                  //     'Bela dekho tumar bolai a text diseni...',
                  //     style: TextStyle(
                  //       color: constantColors.greenColor,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 14.0,
                  //     ),
                  //   ),
                  
                subtitle: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('chatrooms')
                  .doc(documentSnapshot.id).collection('messages')
                  .orderBy('time',descending: true).snapshots(),
                  builder: (context,snapshots){
                    if(snapshots.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),); 
                    }
                    else if(!snapshots.hasData){
                      return Container(height: 0,width:0);
                    }
                    else if((snapshots.data as dynamic).docs.first.data['username']!=
                    null && (snapshots.data as dynamic).docs.first.data['message']!= null ){
                      return Text(
                        '${(snapshots.data as dynamic).docs.first.data['username']} : ${(snapshots.data as dynamic).docs.first.data['message']}',
                        style: TextStyle(
                          color: constantColors.greenColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    else{
                      return Container(height: 0.0,width: 0.0,);
                    }
                  }),
                leading: CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  backgroundImage: NetworkImage((documentSnapshot.data as dynamic)['userimage']),
                ),
              );
            }).toList(),
          );
        }
      });
  }

  showLastMessageTime(dynamic timeData){
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    latestmessagetime = timeago.format(dateTime);
    notifyListeners();
  }
}