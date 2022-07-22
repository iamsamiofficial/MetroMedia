
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/LandingPage/landingServices.dart';
import 'package:metromedia/services/FirebaseOperations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';


class LandingUtils with ChangeNotifier{
  ConstantColors constantColors = ConstantColors();
  final picker = ImagePicker();
  late File  userAvatar;
  File get getUserAvatar => userAvatar;
  String ? userAvatarUrl;
  String ? get gerUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context,ImageSource source) async{
    final pickedUserAvatar = await picker.pickImage(source: source);
    pickedUserAvatar == null ? print('select Image') :  userAvatar = File(pickedUserAvatar.path);
    print(userAvatar.toString());

    userAvatar != null ? Provider.of<LandingService>(context).showUserAvatar(context): Container(height: 0.0,width: 0.0,);
    notifyListeners();
  }

  Future selectAvatarOptions(BuildContext context) async {
    return showModalBottomSheet(
    context: context,
    builder: (context){
      return Container(
        child: Column(
          children: [
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: constantColors.blueColor,
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                    ),
                  onPressed: (){
                    pickUserAvatar(context,ImageSource.gallery).whenComplete((){
                      Navigator.pop(context);
                      Provider.of<LandingService>(context,listen: false).showUserAvatar(context);
                    });
                  }
                  ),
                  MaterialButton(
                  color: constantColors.blueColor,
                  child: Text(
                    'Camera',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                    ),
                  onPressed: (){
                    pickUserAvatar(context,ImageSource.camera).whenComplete((){
                      Navigator.pop(context);
                      Provider.of<LandingService>(context,listen: false).showUserAvatar(context);
                    });
                  }
                  ),
              ],
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.blueGreyColor,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }
    );
  }
}