import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/Chatroom/Chatroom.dart';
import 'package:metromedia/screens/Homepage/Homepage.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:metromedia/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessageHelper with ChangeNotifier{
 late String lastmessagetime;
  String get getlastmessagetime => lastmessagetime;
  bool hasMemberJoined = false;
  bool get gethasMemberJoined => hasMemberJoined;
  ConstantColors constantColors = ConstantColors();

  leaveGroup(BuildContext context,String chatRoomName){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            'Leave $chatRoomName',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
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
                  FirebaseFirestore.instance.collection('chatrooms')
                  .doc(chatRoomName).collection('members')
                  .doc(Provider.of<Authentication>(context,listen: false).getUserUid)
                  .delete().whenComplete(() {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: Homepage(), type: PageTransitionType.bottomToTop));
                  });
                }),
            ],
        );
      },
      );
  }

  showMessage(BuildContext context,DocumentSnapshot documentSnapshot,String adminUserId){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatrooms').doc(documentSnapshot.id)
      .collection('messages').orderBy('time',descending: true).snapshots(),
      
      builder: (context,snapshots){
        
        if(snapshots.connectionState == ConnectionState.waiting){
          return Center(child:CircularProgressIndicator());
        }
        else{
          return ListView(
            reverse: true,
            children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot) {
              showLastMessageTime((documentSnapshot.data as dynamic)['time']);
              return Padding(
                padding: const EdgeInsets.only(top:4.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.235,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:60.0,top: 20),
                        child: Row(
                          children: [
                            Container(
                              constraints:BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.15,
                                maxWidth: MediaQuery.of(context).size.width * 0.8,
                              ) ,

                              child: Padding(
                                padding: const EdgeInsets.only(left:18.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Text(
                                            (documentSnapshot.data as dynamic)['username'],
                                            style: TextStyle(
                                              color: constantColors.greenColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                            ),
                                          Provider.of<Authentication>(context,listen: false).getUserUid
                                          == adminUserId
                                          ? Icon(FontAwesomeIcons.chessKing,color: constantColors.yellowColor,size: 12.0,)
                                          : Container(height:0.0,width:0.0)
                                        ],
                                      ),
                                    ),
                                    Text(
                                      (documentSnapshot.data as dynamic)['message'],
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 14.0,
                                      ),
                                      ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        getlastmessagetime,
                                        style: TextStyle(
                                          color: constantColors.blueColor,
                                          fontSize: 10.0
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Provider.of<Authentication>(context,listen: false).getUserUid
                                == (documentSnapshot.data as dynamic)['useruid']
                                ? constantColors.blueGreyColor.withOpacity(0.8)
                                : constantColors.blueGreyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        //left: 50.0,
                        child: Provider.of<Authentication>(context,listen: false).getUserUid 
                        == (documentSnapshot.data as dynamic)['useruid']
                        ? Container(height: 0,width:0,
                          // child: Column(
                          //   children: [
                          //     IconButton(
                          //       onPressed: (){}, 
                          //       icon: Icon(Icons.edit,color: constantColors.blueColor,size: 18.0,)),
                          //     IconButton(
                          //       onPressed: (){}, 
                          //       icon: Icon(FontAwesomeIcons.trashAlt,color: constantColors.redColor,size: 18.0,)),
                                
                          //   ],
                          // ),
                        ):Container(height: 0,width: 0,),
                        ),
                      Positioned(
                        left: 40.0,
                        child: Provider.of<Authentication>(context,listen: false).getUserUid 
                        == (documentSnapshot.data as dynamic)['useruid']
                        ? Container(height: 0.0,width: 0.0,)
                        : CircleAvatar(
                          backgroundColor: constantColors.darkColor,
                          backgroundImage: NetworkImage((documentSnapshot.data as dynamic)['userimage']),
                        ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      });
  }
  sendMessage(BuildContext context,DocumentSnapshot documentSnapshot,TextEditingController messageController){
    return FirebaseFirestore.instance.collection('chatrooms')
    .doc(documentSnapshot.id).collection('messages').add({
      'message':messageController.text,
      'time':Timestamp.now(),
      'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
      'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
      'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
    }).whenComplete(() {
      messageController.clear();
    });

  }

  Future checkIfJoined(BuildContext context,String chatRoomName,String chatRoomAdminUid) async{
    return FirebaseFirestore.instance.collection('chatrooms')
    .doc(chatRoomName).collection('members')
    .doc(Provider.of<Authentication>(context,listen: false).getUserUid)
    .get().then((value){
      hasMemberJoined = false;
      print('Initial State = ${hasMemberJoined}');
      if((value.data as dynamic)['joined'] != null){
        hasMemberJoined = (value.data as dynamic)['joined'];
        print('Final State = ${hasMemberJoined}');
        notifyListeners();
      }
      if(Provider.of<Authentication>(context,listen: false).getUserUid == chatRoomAdminUid){
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoin(BuildContext context,String roomname){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            'Join $roomname?',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            ),
          actions: [
            MaterialButton(
              onPressed: (){
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: Homepage(),
                    type: PageTransitionType.bottomToTop),
                  );
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 14.0,
                  decoration: TextDecoration.underline,
                  decorationColor: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              ),

               MaterialButton(
                 color: constantColors.blueColor,
              onPressed: () async {
                FirebaseFirestore.instance.collection('chatrooms')
                .doc(roomname)
                .collection('members')
                .doc(Provider.of<Authentication>(context,listen: false).getUserUid)
                .set(
                  {
                    'joined':true,
                    'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
                    'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
                    'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
                    'time':Timestamp.now(),
                  }
                ).whenComplete(() {
                  Navigator.pop(context);
                });
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 14.0,
                  
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              ),
          ],
        );
      });
  }

  showLastMessageTime(dynamic timedata){
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    lastmessagetime = timeago.format(dateTime);
    print(lastmessagetime);
    notifyListeners();
  }
}