import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_c/screens/add_post_screen.dart';
import 'package:instagram_c/screens/feed_screen.dart';
import 'package:instagram_c/screens/profile_screen.dart';
import 'package:instagram_c/screens/search_screen.dart';

var webScreenSize = 600;

var home = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("faviourite"),
  ProfileScreen()
  //uid: FirebaseAuth.instance.currentUser!.uid)
];
