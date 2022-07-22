import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/Feed/Feed.dart';
import 'package:metromedia/screens/Homepage/Homepage.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../screens/LandingPage/landingServices.dart';
import '../screens/LandingPage/landingUtils.dart';
import '../services/FirebaseOperations.dart';

class UploadPost with ChangeNotifier{
  TextEditingController captionController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  final picker = ImagePicker();
  File  UploadPostImage = File('');
  File get getUploadPostImage => UploadPostImage;
  String ? UploadPostImageUrl;
  String ? get getUploadPostImageUrl => UploadPostImageUrl;
  UploadTask? imagePostUploadTask;

  Future pickUploadPostImage(BuildContext context,ImageSource source) async{
    final UploadPostImageVal = await picker.pickImage(source: source);
    UploadPostImage == null ? print('select Image') :  UploadPostImage = File(UploadPostImageVal!.path);
    print(UploadPostImageVal!.path);

    UploadPostImage != null ? Provider.of<UploadPost>(context,listen: false).showPostImage(context): print("Error occured");
    notifyListeners();
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
      'posts/${UploadPostImage.path}/${TimeOfDay.now()}'
    );
    imagePostUploadTask = imageReference.putFile(UploadPostImage);
    await imagePostUploadTask?.whenComplete((){
      print('Post image uploaded storage');
    });
    imageReference.getDownloadURL().then((imageUrl){
      UploadPostImageUrl = imageUrl;
      print(UploadPostImageUrl);
    });
    notifyListeners();
  }
  
  selectPostImageType(BuildContext context){
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.circular(12),
          ),
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
                    onPressed: (){
                      pickUploadPostImage(context,ImageSource.gallery).whenComplete((){
                        Navigator.pop(context);
                        showPostImage(context);
                      });
                    },
                    color: constantColors.blueColor,
                    child: Text(
                      'Gallery',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      ),
                    ),
                    MaterialButton(
                    onPressed: (){
                      pickUploadPostImage(context,ImageSource.camera).whenComplete((){
                        Navigator.pop(context);
                        showPostImage(context);
                      });
                    },
                    color: constantColors.blueColor,
                    child: Text(
                      'Camera',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
      );
  }

  showPostImage(BuildContext context){
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.38,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
             Padding(
               padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
               child: Container(
                 height: 200.0,
                 width: 400.0,
                 child: Image.file(UploadPostImage,fit: BoxFit.contain,),
               ),
             ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                          child: Text('Reselect',style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: constantColors.whiteColor,
                          ),),
                          onPressed: (){
                            selectPostImageType(context);
                          }),

                          MaterialButton(
                            color: constantColors.blueColor,
                            child: Text('Confirm Image',style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              ),
                            ),
                          onPressed: (){
                            // Provider.of<FirebaseOperations>(context,listen: false).uploadUserAvatar(context).whenComplete((){
                            //   Provider.of<LandingService>(context,listen: false).signInSheet(context);
                            // });
                            uploadPostImageToFirebase().whenComplete((){
                              editPostSheet(context);
                              print('Image uploaded');
                            });
                          }),
                  ],
                ),
              )
             
            ],
          ),
        );
      },
      );
  }

  editPostSheet(BuildContext context){
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context){
        return Container(
          // ignore: sort_child_properties_last
          child: Column(
            children: [
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: (){},
                            icon: Icon(
                              Icons.image_aspect_ratio,
                              color: constantColors.greenColor,
                              ),
                            ),
                            IconButton(
                            onPressed: (){},
                            icon: Icon(
                              Icons.fit_screen,
                              color: constantColors.yellowColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200.0,
                      width: 300.0,
                      child: Image.file(UploadPostImage,fit: BoxFit.contain,),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: Image.asset('assets/icons/sunflower.png'),
                    ),
                    Container(
                      height: 110.0,
                      width: 5.0,
                      color: constantColors.blueColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Container(
                        height: 120.0,
                        width: 330.0,
                        child: TextField(
                          maxLines: 5,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          maxLength: 100,

                          controller: captionController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Write a caption...',
                            hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              MaterialButton(
                color: constantColors.blueColor,
                child: Text(
                  'Share',
                  style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                  ),
                  ),
                onPressed: () async {
                  Provider.of<FirebaseOperations>(context,listen: false).uploadPostData(
                    captionController.text,
                    {
                      'postimage':getUploadPostImageUrl,
                      'caption':captionController.text,
                      'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
                      'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
                      'useremail':Provider.of<FirebaseOperations>(context,listen: false).getInitUserEmail,
                      'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
                      'time':Timestamp.now(),
                    }
                    ).whenComplete(() async{
                      //Add Data underuserProfile
                      await FirebaseFirestore.instance.collection('users').doc(
                        Provider.of<Authentication>(context,listen: false).getUserUid
                      ).collection('posts').doc(captionController.text).set(
                        {
                      'postimage':getUploadPostImageUrl,
                      'caption':captionController.text,
                      'username':Provider.of<FirebaseOperations>(context,listen: false).getInitUserName,
                      'userimage':Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage,
                      'useremail':Provider.of<FirebaseOperations>(context,listen: false).getInitUserEmail,
                      'useruid':Provider.of<Authentication>(context,listen: false).getUserUid,
                      'time':Timestamp.now(),
                    }
                      );
                    }).whenComplete((){
                      
                      
                      Navigator.pushReplacement(context, PageTransition(child: Homepage(), type: PageTransitionType.leftToRight));
                      captionController.clear();
                      notifyListeners();
                    });
                },
                ),
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
        );
      },
      );
  }



    // final picker = ImagePicker();
  // late File  userAvatar;
  // File get getUserAvatar => userAvatar;
  // String ? userAvatarUrl;
  // String ? get gerUserAvatarUrl => userAvatarUrl;

  // Future pickUserAvatar(BuildContext context,ImageSource source) async{
  //   final pickedUserAvatar = await picker.pickImage(source: source);
  //   pickedUserAvatar == null ? print('select Image') :  userAvatar = File(pickedUserAvatar.path);
  //   print(userAvatar.toString());

  //   userAvatar != null ? Provider.of<LandingService>(context).showUserAvatar(context): print("Error occured");
  //   notifyListeners();
  // }

  // Future selectAvatarOptions(BuildContext context) async {
  //   return showModalBottomSheet(
  //   context: context,
  //   builder: (context){
  //     return Container(
  //       child: Column(
  //         children: [
  //           Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 150.0),
  //                 child: Divider(
  //                   thickness: 4.0,
  //                   color: constantColors.whiteColor,
  //                 ),
  //               ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               MaterialButton(
  //                 color: constantColors.blueColor,
  //                 child: Text(
  //                   'Gallery',
  //                   style: TextStyle(
  //                     color: constantColors.whiteColor,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 18.0,
  //                   ),
  //                   ),
  //                 onPressed: (){
  //                   pickUserAvatar(context,ImageSource.gallery).whenComplete((){
  //                     Navigator.pop(context);
  //                     Provider.of<LandingService>(context,listen: false).showUserAvatar(context);
  //                   });
  //                 }
  //                 ),
  //                 MaterialButton(
  //                 color: constantColors.blueColor,
  //                 child: Text(
  //                   'Camera',
  //                   style: TextStyle(
  //                     color: constantColors.whiteColor,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 18.0,
  //                   ),
  //                   ),
  //                 onPressed: (){
  //                   pickUserAvatar(context,ImageSource.camera).whenComplete((){
  //                     Navigator.pop(context);
  //                     Provider.of<LandingService>(context,listen: false).showUserAvatar(context);
  //                   });
  //                 }
  //                 ),
  //             ],
  //           ),
  //         ],
  //       ),
  //       height: MediaQuery.of(context).size.height * 0.1,
  //       width: MediaQuery.of(context).size.width,
  //       decoration: BoxDecoration(
  //         color: constantColors.blueGreyColor,
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //     );
  //   }
  //   );
  // }
  //  showUserAvatar(BuildContext context){
  //   return showModalBottomSheet(
  //     context: context,
  //     builder: (context){
  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.30,
  //         width: MediaQuery.of(context).size.width,
  //         child: Column(
  //           children: [
  //             Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 150.0),
  //                 child: Divider(
  //                   thickness: 4.0,
  //                   color: constantColors.whiteColor,
  //                 ),
  //               ),
  //               CircleAvatar(
  //                 radius: 80.0,
  //                 backgroundColor: constantColors.transperant,
  //                 backgroundImage: FileImage(
  //                   Provider.of<LandingUtils>(context).userAvatar)
  //               ),
  //               Container(
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     MaterialButton(
  //                       child: Text('Reselect',style: TextStyle(
  //                         color: constantColors.whiteColor,
  //                         fontWeight: FontWeight.bold,
  //                         decoration: TextDecoration.underline,
  //                         decorationColor: constantColors.whiteColor,
  //                       ),),
  //                       onPressed: (){
  //                         Provider.of<LandingUtils>(context,listen: false).pickUserAvatar(
  //                           context, ImageSource.gallery);
  //                       }),

  //                       MaterialButton(
  //                         color: constantColors.blueColor,
  //                         child: Text('Confirm Image',style: TextStyle(
  //                           color: constantColors.whiteColor,
  //                           fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       onPressed: (){
  //                         Provider.of<FirebaseOperations>(context,listen: false).uploadUserAvatar(context).whenComplete((){
  //                           Provider.of<LandingService>(context,listen: false).signInSheet(context);
  //                         });
  //                       }),
  //                   ],
  //                 ),
  //               ),
    
  //           ],
  //         ),
  //         decoration: BoxDecoration(
  //           color: constantColors.blueGreyColor,
  //           borderRadius: BorderRadius.circular(15.0),
  //         ),
  //       );
  //     }
  //     );
  // }
}