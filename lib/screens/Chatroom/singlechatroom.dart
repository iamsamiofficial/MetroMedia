import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/Chatroom/singlechatroomhelper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../Homepage/Homepage.dart';

class SingleChatroom extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
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
                text: 'Messenger',
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          ),
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
          
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<SingleChatroomHelper>(context,listen: false).showChatrooms(context),
      ),
    );
  }
}