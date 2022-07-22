import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/AltProfile/alt_profile_helper.dart';
import 'package:metromedia/screens/Chatroom/ChatroomHelper.dart';
import 'package:metromedia/screens/Chatroom/singlechatroomhelper.dart';
import 'package:metromedia/screens/Feed/FeedHelpers.dart';
import 'package:metromedia/screens/Homepage/HomepageHelper.dart';
import 'package:metromedia/screens/LandingPage/landingHelpers.dart';
import 'package:metromedia/screens/LandingPage/landingServices.dart';
import 'package:metromedia/screens/LandingPage/landingUtils.dart';
import 'package:metromedia/screens/Messaging/groupMessageHelper.dart';
import 'package:metromedia/screens/Messaging/singleMessageHelper.dart';
import 'package:metromedia/screens/Profile/ProfileHelpers.dart';
import 'package:metromedia/screens/SplashScreen/splashScreen.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:metromedia/services/FirebaseOperations.dart';
import 'package:metromedia/utils/PostOption.dart';
import 'package:metromedia/utils/UploadPost.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      child: MaterialApp(
        home: Splashscreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: constantColors.blueColor,
          fontFamily: 'Poppins',
          canvasColor: Colors.transparent,
          ),
        ),
      providers: [
        ChangeNotifierProvider(create: (_)=> SingleChatroomHelper()),
        ChangeNotifierProvider(create: (_)=> SingleMessageHelper()),
        ChangeNotifierProvider(create: (_)=> GroupMessageHelper()),
        ChangeNotifierProvider(create: (_)=> ChatroomHelper()),
        ChangeNotifierProvider(create: (_)=> AltProfileHelper()),
        ChangeNotifierProvider(create: (_)=> PostFunctions()),
        ChangeNotifierProvider(create: (_)=> FeedHelpers()),
        ChangeNotifierProvider(create: (_)=> UploadPost()),
        ChangeNotifierProvider(create: (_)=> ProfileHelpers()),
        ChangeNotifierProvider(create: (_)=> HomepageHelpers()),
        ChangeNotifierProvider(create: (_)=> LandingUtils()),
        ChangeNotifierProvider(create: (_)=> FirebaseOperations()),
        ChangeNotifierProvider(create: (_)=> LandingService()),
        ChangeNotifierProvider(create: (_)=> Authentication()),
        ChangeNotifierProvider(create: (_)=> LandingHelpers()),
        
      ]);
    
  }
}