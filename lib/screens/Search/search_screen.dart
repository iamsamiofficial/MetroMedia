import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/AltProfile/alt_profile.dart';
import 'package:metromedia/screens/Profile/Profile.dart';
import 'package:metromedia/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../Homepage/Homepage.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ConstantColors constantColors = ConstantColors();
  TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: constantColors.darkColor,
        title: TextFormField(
          style: TextStyle(color: constantColors.whiteColor),
          controller: searchController,
          decoration: const InputDecoration(
            labelText: "Search for a muia'n...",
            labelStyle: TextStyle(color: Colors.white),
          ),
          onFieldSubmitted: (String _){
            setState(() {
              isShowUser = true;
            });
            
          },
        ),
        
      ),
      body: isShowUser? FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('username',isGreaterThanOrEqualTo: searchController.text).get(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context,index){
              return InkWell(
                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: ((context){
                  return Container(
                    child: (snapshot.data! as dynamic).docs[index]['useruid'] != Provider.of<Authentication>(context,listen: false).getUserUid
                    ?AltProfile(useruid: (snapshot.data! as dynamic).docs[index]['useruid'])
                    : Profile(),
                  );
                })),),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['userimage'],
                    ),
                  ),
                  title: Text((snapshot.data! as dynamic).docs[index]['username'],
                  style: TextStyle(
                    color: constantColors.whiteColor,
                  ),
                  ),
                ),
              );
            },
            );
        },
        ):FutureBuilder(
          future: FirebaseFirestore.instance.collection('posts').get(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return StaggeredGridView.countBuilder(
              crossAxisCount: 3,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context,index)=>
                Image.network((snapshot.data! as dynamic).docs[index]['postimage']),
              
              staggeredTileBuilder: (index)=> StaggeredTile.count(
                (index % 7 == 0) ?2 :1,
                (index % 7 == 0) ?2 :1,
                ),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              );

          },
          ),
    );
  }
}