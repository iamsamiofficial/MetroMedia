import 'package:flutter/material.dart';
import 'package:metro_media/screens/add_post_screen.dart';
import 'package:metro_media/screens/weather_screen.dart';

import '../screens/feed_screen.dart';

const webScreenSize = 600;

const homeScreenItem = [
  FeedScreen(),
  Center(child: Text('Search Here...')),
  AddPostScreen(),
  Center(child: Text('Do you want to see how many reacts you got?')),
  Center(child: Text('About You')),
  Home(),
];