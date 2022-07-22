import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/LandingPage/landingHelpers.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:metromedia/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../Homepage/Homepage.dart';
import 'landingUtils.dart';
class LandingService with ChangeNotifier{
  TextEditingController userNameController = TextEditingController();
  TextEditingController userMetroController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  ConstantColors constantColors = ConstantColors();

  showUserAvatar(BuildContext context){
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: constantColors.transperant,
                  backgroundImage: FileImage(
                    Provider.of<LandingUtils>(context).userAvatar)
                ),
                Container(
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
                          Provider.of<LandingUtils>(context,listen: false).pickUserAvatar(
                            context, ImageSource.gallery);
                        }),

                        MaterialButton(
                          color: constantColors.blueColor,
                          child: Text('Confirm Image',style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            ),
                          ),
                        onPressed: (){
                          Provider.of<FirebaseOperations>(context,listen: false).uploadUserAvatar(context).whenComplete((){
                            Provider.of<LandingService>(context,listen: false).signInSheet(context);
                          });
                        }),
                    ],
                  ),
                ),
    
            ],
          ),
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.circular(15.0),
          ),
        );
      }
      );
  }
  
  Widget passwordLessSignIn(BuildContext context){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            return  ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
                
                return  ListTile(
                  trailing: Container(
                    height: 50.0,
                    width: 120.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: (){
                            Provider.of<Authentication>(context,listen: false).logIntoAccount(
                              (documentSnapshot.data as dynamic)['useremail'],
                              (documentSnapshot.data as dynamic)['userpassword'],
                              ).whenComplete((){
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(child:Homepage(),
                                  type: PageTransitionType.leftToRight,
                                  ),
                                  );
                              });
                          },
                          icon: Icon(FontAwesomeIcons.check,color: constantColors.blueColor,)),
                        IconButton(
                          onPressed: (){
                            Provider.of<FirebaseOperations>(context,listen: false).deleteUserData(
                              (documentSnapshot.data as dynamic)['useruid'],'users',
                            );
                          },
                          icon: Icon(FontAwesomeIcons.trashAlt,color: constantColors.redColor,)),
                      ],
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: constantColors.darkColor,
                    backgroundImage: NetworkImage((documentSnapshot.data as dynamic)['userimage']),
                  ),
                  subtitle:Text((documentSnapshot.data as dynamic)['useremail'],style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: constantColors.whiteColor,
                  ),), 
                  title: Text((documentSnapshot.data as dynamic)['username'],style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: constantColors.greenColor,
                  ),),
                );
              }).toList()
            );
          }
        }),
    );
  }

  loginSheet(BuildContext context){
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context){
        return Padding(
          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userEmailController,
                    decoration: InputDecoration(
                      hintText: 'Enter Email...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Enter Password...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                  ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: (){
                    if(userEmailController.text.isNotEmpty){
                      Provider.of<Authentication>(context,listen: false).logIntoAccount(
                        userEmailController.text,
                        userPasswordController.text,
                        ).whenComplete((){
                          
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: Homepage(),
                              type: PageTransitionType.bottomToTop,
                              ),
                            );
                          userEmailController.clear();
                          userPasswordController.clear();
                          notifyListeners();
                        });
                    }
                    else{
                      warningText(context,'Fill all the data!');
                    }
                  },
                  backgroundColor: constantColors.blueColor,
                  child: Icon(
                    FontAwesomeIcons.check,
                    color: constantColors.whiteColor,
                  ),
                  
                  )

              ],
            ),
          ),
        );
      }
      );
  }

  signInSheet(BuildContext context){
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context){
        return Padding(
          padding:  EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
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
                CircleAvatar(
                  backgroundImage: FileImage(
                    Provider.of<LandingUtils>(context,listen:false).getUserAvatar,
                  ),
                  backgroundColor: constantColors.redColor,
                  radius: 60.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Name...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userMetroController,
                    decoration: InputDecoration(
                      
                      hintText: 'Enter Your Metro ID...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userEmailController,
                    decoration: InputDecoration(
                      hintText: 'Enter Email...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Enter Password...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: FloatingActionButton(
                    onPressed: (){
                      if(userEmailController.text.isNotEmpty){
                        Provider.of<Authentication>(context,listen: false).createAccount(
                          userEmailController.text,
                          userPasswordController.text,
                          ).whenComplete((){
                            print('creating user collection');
                            Provider.of<FirebaseOperations>(context,
                            listen: false).createUserCollection(context, {
                              'useruid': Provider.of<Authentication>(context,listen: false).getUserUid,
                              'usermetro':userMetroController.text,
                              'useremail':userEmailController.text,
                              'userpassword':userPasswordController.text,
                              'username':userNameController.text,
                              'userimage':Provider.of<LandingUtils>(context,listen: false).gerUserAvatarUrl,
                            });
                          }).whenComplete((){
                            
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: Homepage(),
                              type: PageTransitionType.bottomToTop,
                              ),
                            );
                            userMetroController.clear();
                            userNameController.clear();
                            userEmailController.clear();
                            userPasswordController.clear();
                            notifyListeners();
                        });
                      }
                      else{
                        warningText(context,'Fill all the data!');
                      }
                    },
                    backgroundColor: constantColors.redColor,
                    child: Icon(
                      FontAwesomeIcons.check,
                      color: constantColors.whiteColor,
                    ),
                    
                    ),
                )
              ],
            
            ),
          ),
        );
      },
      );
  }
  warningText(BuildContext context,String warning){
    return showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(15.0),
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child:Text(
              warning,
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              ),
              ),
        );
      }
      );
  }
}