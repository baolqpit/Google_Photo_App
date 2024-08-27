import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_photo_app/screens/homepage/homepage_screen.dart';

class ScreensAndMenus {
  static List<BottomNavigationBarItem> listCustomerIcons =
  const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        label: 'Images',
        icon: Icon(Icons.image),),
    BottomNavigationBarItem(
      label: 'Albums',
      icon: Icon(Icons.photo_album_outlined),),
  ];

  static List<Widget> listCustomerScreens = [
    HomepageScreen(),
    Container()
  ];
}