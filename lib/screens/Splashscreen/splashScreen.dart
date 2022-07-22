import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/LandingPage/landingPage.dart';
import 'package:page_transition/page_transition.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  ConstantColors constantColors = ConstantColors();

  @override
  void initState() {
    Timer(
      Duration(seconds: 2),
      (() => Navigator.pushReplacement(context, PageTransition(child: Landingpage(), type: PageTransitionType.leftToRight))
      )
    );
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  constantColors.darkColor,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment:CrosssAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text:"Metro",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
                children: <TextSpan>
                [
                  TextSpan(
                    text: 'Media',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                ),
                
                    
                  ),
                  
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}