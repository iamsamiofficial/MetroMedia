
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/Messaging/singleMessageHelper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../services/Authentication.dart';
import '../Homepage/Homepage.dart';

class SingleMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  SingleMessage({
    required this.documentSnapshot,
  });

  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  ConstantColors constantColors = ConstantColors();
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed:(){
            Navigator.pushReplacement(
              context, PageTransition(
                child: Homepage(),
                type: PageTransitionType.bottomToTop));
                      
          } ,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: constantColors.whiteColor,
            ),
        ),
        centerTitle: true,
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: constantColors.darkColor,
                backgroundImage: NetworkImage((widget.documentSnapshot.data as dynamic)['endimage']),

              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text(
                    (widget.documentSnapshot.data as dynamic)['endname'],
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
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                
                child:Provider.of<SingleMessageHelper>(context,listen: false)
                .showMessage(context, widget.documentSnapshot),
                duration: Duration(seconds: 1),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                curve: Curves.bounceIn,
              ),
              Row(
                children: [
                  Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Drop a hi...',
                              hintStyle: TextStyle(
                              color: constantColors.greenColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        child: Icon(Icons.send_sharp ,color: constantColors.whiteColor,),
                        onPressed: (){
                          if(messageController.text.isNotEmpty){
                            Provider.of<SingleMessageHelper>(context,listen: false)
                            .sendMessage(context, widget.documentSnapshot, messageController);
                          }
                        },
                        )
                ],
              )
                    ],
                  ),
                ),
              ),
            
          
      
    );
  }
  sendMessage(BuildContext context,DocumentSnapshot documentSnapshot,TextEditingController messageController){
    return FirebaseFirestore.instance.collection('userchatroom')
    .doc(documentSnapshot.id).collection('metromediachats').doc(Provider.of<Authentication>(context,listen: false).getUserUid)
    .collection('messages').add({
      'message':messageController.text,
      // 'time':Timestamp.now(),
      // 'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
      // 'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
      // 'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
    }).whenComplete((){
      FirebaseFirestore.instance.collection('userchatroom')
    .doc(Provider.of<Authentication>(context,listen: false).getUserUid).collection('metromediachats').doc(documentSnapshot.id)
    .collection('messages').add({
      'message':messageController.text,
      // 'time':Timestamp.now(),
      // 'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
      // 'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
      // 'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
    }).whenComplete(() {
      messageController.clear();
    });
    });

  }
}