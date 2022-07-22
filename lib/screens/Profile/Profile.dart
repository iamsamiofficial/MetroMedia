import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/LandingPage/landingPage.dart';
import 'package:metromedia/screens/Profile/ProfileHelpers.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){},
          icon: Icon(EvaIcons.settings2Outline,color: constantColors.lightBlueColor,),
          ),
        actions: [
          IconButton(
            onPressed: (){
              Provider.of<ProfileHelpers>(context,listen: false).logOutDialog(context);
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.greenColor,
              ),
            ),
        ],
        centerTitle: true,
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: 'My ',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Profile',
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(
                Provider.of<Authentication>(context,listen: false).getUserUid
              ).snapshots(),
              builder: (context,snapshots){
                if(snapshots.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else{
                  return Column(
                    children: [
                      Provider.of<ProfileHelpers>(context,listen: false).headerProfile(context,snapshots),
                      Provider.of<ProfileHelpers>(context,listen: false).divider(),
                      Provider.of<ProfileHelpers>(context,listen: false).middleProfile(context, snapshots),
                      Provider.of<ProfileHelpers>(context,listen: false).footerProfile(context, snapshots),
                    ],
                  );
                }
              }),
              
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: constantColors.blueGreyColor.withOpacity(0.6),
            ),
          ),
        ),

      ),
    );
  }
}