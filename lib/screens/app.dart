import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';
import 'package:google_photo_app/share/screens%20and%20menus/screens_and_menus.dart';

class PhotoApp extends StatefulWidget {
  const PhotoApp({super.key});

  @override
  State<PhotoApp> createState() => _PhotoAppState();
}

class _PhotoAppState extends State<PhotoApp> {
  final AppController appController = Get.find();
  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildAppBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  _buildAppBody(){
    return Obx(() => SafeArea(
      child: ScreensAndMenus.listCustomerScreens
          .elementAt(appController.currentBottomIndex.value!),
    ));
  }

  _buildBottomBar(){
    return Obx(() => BottomNavigationBar(
      items: ScreensAndMenus.listCustomerIcons,
      unselectedLabelStyle: const TextStyle(fontSize: Dimens.font_size_min),
      showUnselectedLabels: true,
      unselectedItemColor: AppColor.black,
      selectedItemColor: AppColor.primary,
      selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: Dimens.font_size_min),
      currentIndex: appController.currentBottomIndex.value!,
      onTap: (index) {
        if (mounted) {
          appController.currentBottomIndex.value = index;
        }
      },
    ));
  }

  _buildAppBar(){
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(
            Dimens.padding_8), // Adds some padding around the avatar
        child: CircleAvatar(
          radius: 20, // Sets the size of the avatar
          backgroundImage: NetworkImage(userController.user.value!.photoUrl!),
        ),
      ),
      title: AppText(content: '${userController.user.value!.displayName}'),
    );
  }
}
