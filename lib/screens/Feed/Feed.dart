import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:metromedia/constants/Constantcolors.dart';
import 'package:metromedia/screens/Feed/FeedHelpers.dart';
import 'package:provider/provider.dart';

class Feed extends StatelessWidget {
  
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      drawer: Drawer(),
      appBar: Provider.of<FeedHelpers>(context,listen: false).appBar(context),
      body: Provider.of<FeedHelpers>(context,listen: false).feedBody(context),
    );
  }
}