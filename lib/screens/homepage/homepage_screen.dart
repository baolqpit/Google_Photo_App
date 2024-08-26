import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';
import 'package:google_photo_app/share/functions/functions.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final UserController userController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    onWidgetBuildDone(() async {
      await userController.getAlbums();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(Dimens.padding_8), // Adds some padding around the avatar
          child: CircleAvatar(
            radius: 20, // Sets the size of the avatar
            backgroundImage: NetworkImage(userController.user.value!.photoUrl!),
          ),
        ),
        title: AppText(content: '${userController.user.value!.displayName}'),
      ),
    );
  }
}
