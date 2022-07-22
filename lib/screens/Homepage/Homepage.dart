import 'package:flutter/material.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/Chatroom/Chatroom.dart';
import 'package:metromedia/screens/Feed/Feed.dart';
import 'package:metromedia/screens/Homepage/HomepageHelper.dart';
import 'package:metromedia/screens/Profile/Profile.dart';
import 'package:metromedia/screens/Search/search_screen.dart';
import 'package:metromedia/screens/Weather/weather_screen.dart';
import 'package:metromedia/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';


class Homepage extends StatefulWidget {

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FirebaseOperations>(context,listen: false).initUserData(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homepageController,
        children: [Feed(),SearchScreen(),Chatroom(),Home(),Profile()],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page){
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomepageHelpers>(context).bottomNavbar(context,pageIndex, homepageController),
    );
  }
}