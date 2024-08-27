import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_photo_app/screens/homepage/albums_screens/album_screens.dart';
import 'package:google_photo_app/screens/homepage/images_screens/homepage_screen.dart';

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
    const HomepageScreen(),
    const AlbumScreens()
  ];
}