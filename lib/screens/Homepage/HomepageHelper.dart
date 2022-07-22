import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class HomepageHelpers with ChangeNotifier{
  ConstantColors constantColors = ConstantColors();

  Widget bottomNavbar(BuildContext context, int index,PageController pageController){
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.5,
      iconSize: 30.0,
      onTap: (val){
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      backgroundColor: Color(0xff040307),
      items: [
        CustomNavigationBarItem(icon: Icon(Icons.home)),
        CustomNavigationBarItem(icon: Icon(Icons.search_outlined)),
        CustomNavigationBarItem(icon: Icon(Icons.message_rounded)),
        CustomNavigationBarItem(icon: Icon(EvaIcons.sunOutline)),
         CustomNavigationBarItem(icon: CircleAvatar(
           radius: 35.0,
           backgroundColor: constantColors.blueGreyColor,
           backgroundImage: NetworkImage(Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage),
           
         )),
      ]);
  }
}