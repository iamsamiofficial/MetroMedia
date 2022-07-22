import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/Chatroom/ChatroomHelper.dart';
import 'package:provider/provider.dart';

class Chatroom extends StatelessWidget {
  final constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.blueGreyColor,
        child: Icon(FontAwesomeIcons.plus,color: constantColors.greenColor),
        onPressed: (){
          Provider.of<ChatroomHelper>(context,listen:false).showCreateChatroomSheet(context);
        },
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Provider.of<ChatroomHelper>(context,listen:false).showCreateChatroomSheet(context);
            },
            icon: Icon(
              FontAwesomeIcons.plus,
              color: constantColors.greenColor,
              ),
            ),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(
              EvaIcons.moreVertical,
              color: constantColors.whiteColor,
              ),
            ),
        ],
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        centerTitle: true,
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
                text: 'Group',
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<ChatroomHelper>(context,listen: false).showChatrooms(context),
      ),
    );
  }
}