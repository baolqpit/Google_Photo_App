import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';
import 'package:google_photo_app/share/functions/functions.dart';

class AlbumScreens extends StatefulWidget {
  const AlbumScreens({super.key});

  @override
  State<AlbumScreens> createState() => _AlbumScreensState();
}

class _AlbumScreensState extends State<AlbumScreens> {
  final AppController appController = Get.find();
  final UserController userController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    onWidgetBuildDone(() async => await userController.getAlbums());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(
            vertical: Dimens.padding_vertical,
            horizontal: Dimens.padding_horizontal),
        child: appController.isLoading.value ? const Center(child: CircularProgressIndicator()) : _buildAlbumBody()));
  }

  _buildAlbumBody() {
    return Column(
      children: [_buildTitleAndButtonsAction(), _buildAlbumsList()],
    );
  }
  
  _buildAlbumsList(){
    return Obx(() => Container());
  }

  _buildTitleAndButtonsAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AppText(
          content: 'Albums',
          fontWeight: FontWeight.bold,
          textSize: Dimens.font_size_title,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
              vertical: Dimens.padding_5, horizontal: Dimens.padding_8),
          decoration: BoxDecoration(
              color: AppColor.lightGrey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(Dimens.circular12)),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
