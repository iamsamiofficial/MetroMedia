import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../services/Authentication.dart';
import '../../services/FirebaseOperations.dart';

class SingleMessageHelper with ChangeNotifier{
   late String lastmessagetime;
  String get getlastmessagetime => lastmessagetime;
  ConstantColors constantColors = ConstantColors();
  showMessage(BuildContext context,DocumentSnapshot documentSnapshot){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('userchatroom').doc(documentSnapshot.id)
      .collection('metromediachats').doc(Provider.of<Authentication>(context,listen: false).getUserUid)
    .collection('messages').orderBy('time',descending: true).snapshots(),
      
      builder: (context,snapshots){
        
        if(snapshots.connectionState == ConnectionState.waiting){
          return Center(child:CircularProgressIndicator());
        }
        else{
          return ListView(
            shrinkWrap: true,
            reverse: true,
            children: (snapshots.data as dynamic).docs.map<Widget>((DocumentSnapshot documentSnapshot) {
              showLastMessageTime((documentSnapshot.data as dynamic)['time']);
              return Padding(
                padding: const EdgeInsets.only(top:4.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.135,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:60.0,top: 20),
                        child: Row(
                          children: [
                            Container(
                              constraints:BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.2,
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
              // return ListTile(
              //                         title:(documentSnapshot.data as dynamic)['message'],
              //                         // style: TextStyle(
              //                         //   color: constantColors.whiteColor,
              //                         //   fontSize: 14.0,
              //                         // ),
              //                         );
              // // return Container(
              // //                 constraints:BoxConstraints(
              // //                   maxHeight: MediaQuery.of(context).size.height * 0.1,
              // //                   maxWidth: MediaQuery.of(context).size.width * 0.8,
              // //                 ) ,

              // //                 child: Padding(
              // //                   padding: const EdgeInsets.only(left:18.0),
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         (documentSnapshot.data as dynamic)['message'],
              //                         style: TextStyle(
              //                           color: constantColors.whiteColor,
              //                           fontSize: 14.0,
              //                         ),
              //                         ),
              //                     ],
              //                   ),
              //                 ),
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(8.0),
              //                   color: Provider.of<Authentication>(context,listen: false).getUserUid
              //                   == (documentSnapshot.data as dynamic)['useruid']
              //                   ? constantColors.blueGreyColor.withOpacity(0.8)
              //                   : constantColors.blueGreyColor,
              //                 ),
              // );
              // return Padding(
              //   padding: const EdgeInsets.only(top:4.0),
              //   child: Container(
              //     height: MediaQuery.of(context).size.height * 0.132,
              //     width: MediaQuery.of(context).size.width,
              //     child: Stack(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.only(left:60.0,top: 20),
              //           child: Row(
              //             children: [
              //               Container(
              //                 constraints:BoxConstraints(
              //                   maxHeight: MediaQuery.of(context).size.height * 0.1,
              //                   maxWidth: MediaQuery.of(context).size.width * 0.8,
              //                 ) ,

              //                 child: Padding(
              //                   padding: const EdgeInsets.only(left:18.0),
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         (documentSnapshot.data as dynamic)['message'],
              //                         style: TextStyle(
              //                           color: constantColors.whiteColor,
              //                           fontSize: 14.0,
              //                         ),
              //                         ),
              //                     ],
              //                   ),
              //                 ),
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(8.0),
              //                   color: Provider.of<Authentication>(context,listen: false).getUserUid
              //                   == (documentSnapshot.data as dynamic)['useruid']
              //                   ? constantColors.blueGreyColor.withOpacity(0.8)
              //                   : constantColors.blueGreyColor,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
                      
              //       ],
              //     ),
              //   ),
              // );
            }).toList(),
          );
        }
      });
  }








    sendMessage(BuildContext context,DocumentSnapshot documentSnapshot,TextEditingController messageController){
    return FirebaseFirestore.instance.collection('userchatroom')
    .doc(documentSnapshot.id).collection('metromediachats').doc(Provider.of<Authentication>(context,listen: false).getUserUid)
    .collection('messages').add({
      'message':messageController.text,
      'time':Timestamp.now(),
      'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
      'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
      'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
    }).whenComplete((){
      FirebaseFirestore.instance.collection('userchatroom')
    .doc(Provider.of<Authentication>(context,listen: false).getUserUid).collection('metromediachats').doc(documentSnapshot.id)
    .collection('messages').add({
      'message':messageController.text,
      'time':Timestamp.now(),
      'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
      'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
      'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
    }).whenComplete(() {
      messageController.clear();
    });
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