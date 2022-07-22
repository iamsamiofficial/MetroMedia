import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../services/Authentication.dart';
import '../Messaging/singleMessage.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleChatroomHelper with ChangeNotifier{
  late String latestmessagetime;
  String get getlatestmessagetime => latestmessagetime;
  ConstantColors constantColors = ConstantColors();

  showChatrooms(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('userchatroom').snapshots(),
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
              
              return Container(
                child: (documentSnapshot.data as dynamic)['useruid'] == Provider.of<Authentication>(context).getUserUid
                ?ListTile(
                  
                  onTap: (){
                    Navigator.of(context).pushReplacement(
                      PageTransition(
                        child: SingleMessage(documentSnapshot:documentSnapshot),
                        type: PageTransitionType.bottomToTop),
                        );
                  },
                  title: Text(
                    (documentSnapshot.data as dynamic)['endname'],
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0
                    ),
                    ),
                    trailing: Container(
                      width: 0,
                      child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('userchatroom').doc(documentSnapshot.id)
                    .collection('metromediachats').doc(Provider.of<Authentication>(context,listen: false).getUserUid)
                    .collection('messages').orderBy('time',descending: true).snapshots(),
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
                    //   'Bela dekho tumar bolai a text diseni...',
                    //   style: TextStyle(
                    //     color: constantColors.greenColor,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 14.0,
                    //   ),
                    // ),
                    subtitle: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('userchatroom').doc(documentSnapshot.id)
      .collection('metromediachats').doc(Provider.of<Authentication>(context,listen: false).getUserUid)
    .collection('messages').orderBy('time',descending: true).snapshots(),
                    builder: (context,snapshots){
                      if(snapshots.connectionState == ConnectionState.waiting ){
                        return Center(child: CircularProgressIndicator(),); 
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
                        return Text(
                          'Say HI',
                          style: TextStyle(
                            color: constantColors.greenColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    }),
                  leading: CircleAvatar(
                    backgroundColor: constantColors.transperant,
                    backgroundImage: NetworkImage((documentSnapshot.data as dynamic)['endimage']),
                  ),
                ):Container(height: 0,width: 0,),
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