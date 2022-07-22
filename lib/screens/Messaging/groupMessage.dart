import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/Chatroom/Chatroom.dart';
import 'package:metromedia/screens/Homepage/Homepage.dart';
import 'package:metromedia/screens/Messaging/groupMessageHelper.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';


class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

   GroupMessage({

    required this.documentSnapshot,
    });

  @override
  State<GroupMessage> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  ConstantColors constantColors = ConstantColors();

  final TextEditingController messageController = TextEditingController();

  @override
  void initState(){
    Provider.of<GroupMessageHelper>(context,listen: false)
    .checkIfJoined(
      context,
      widget.documentSnapshot.id,
      (widget.documentSnapshot.data as dynamic)['useruid'],
      ).whenComplete(() async {
        if(Provider.of<GroupMessageHelper>(context,listen: false).gethasMemberJoined == false){
          Timer(
            Duration(milliseconds: 10),
            ()=> Provider.of<GroupMessageHelper>(context,listen: false)
            .askToJoin(context, widget.documentSnapshot.id),
            );
        }
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        actions: [
          Provider.of<Authentication>(context,listen: false).getUserUid == (widget.documentSnapshot.data as dynamic)['useruid']
          ?IconButton(onPressed: (){}, icon: Icon(EvaIcons.moreVertical,color:constantColors.whiteColor))
          : Container(height: 0.0,width: 0.0,),
          IconButton(
            onPressed: (){
              Provider.of<GroupMessageHelper>(context,listen: false).leaveGroup(
                context, widget.documentSnapshot.id);
            },
            icon: Icon(EvaIcons.logOutOutline,color: constantColors.redColor,),
            ),
          
        ],
        leading: IconButton(
          onPressed:(){
            Navigator.of(context).pushReplacement(
                    PageTransition(
                      child: Homepage(),
                      type: PageTransitionType.bottomToTop),
                      );
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
                backgroundImage: NetworkImage((widget.documentSnapshot.data as dynamic)['userimage']),

              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (widget.documentSnapshot.data as dynamic)['roomname'],
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('chatrooms')
                      .doc(widget.documentSnapshot.id).collection('members')
                      .snapshots(),
                      builder: (context,snapshots) {
                        if(snapshots.connectionState == ConnectionState.waiting){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else{
                          return Text(
                      '${(snapshots.data as dynamic).docs.length.toString()} members',
                      style: TextStyle(
                        color: constantColors.greenColor.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    );
                        }
                      },
                      ),
                  ],
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
                
                child:Provider.of<GroupMessageHelper>(context,listen: false)
                .showMessage(context, widget.documentSnapshot, (widget.documentSnapshot as dynamic)['useruid']),
                duration: Duration(seconds: 1),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                curve: Curves.bounceIn,
              ),
              Padding(
                padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: constantColors.transperant,
                          backgroundImage: AssetImage('assets/icons/sunflower.png'),
                        ),
                      ),
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
                            Provider.of<GroupMessageHelper>(context,listen: false)
                            .sendMessage(context, widget.documentSnapshot, messageController);
                          }
                        },
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
  }
}