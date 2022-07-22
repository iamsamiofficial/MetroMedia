
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/AltProfile/alt_profile_helper.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatelessWidget {
  final String useruid;
    AltProfile({
    Key? key,
    required this.useruid,
    }) : super(key: key);
    final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: Provider.of<AltProfileHelper>(context,listen: false).appBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(useruid).snapshots(),
            builder: (context,snapshots){
              if(snapshots.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else{
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Provider.of<AltProfileHelper>(context,listen: false).headerProfile(
                      context,
                      snapshots,
                      useruid),
                    Provider.of<AltProfileHelper>(context,listen: false).divider(),
                    Provider.of<AltProfileHelper>(context,listen: false).middleProfile(context,snapshots),
                    Provider.of<AltProfileHelper>(context,listen: false).footerProfile(context,snapshots),

                  ],
                );
              }
            }),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor.withOpacity(0.6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12)
            ),
          ),
        ),
      ),
    );
  }
}