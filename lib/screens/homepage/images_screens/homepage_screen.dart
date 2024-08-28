import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/screens/homepage/images_screens/choose_album_to_share_screen.dart';
import 'package:google_photo_app/screens/homepage/images_screens/image_details.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';
import 'package:google_photo_app/share/functions/functions.dart';
import 'package:google_photo_app/share/widgets/dialogs.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final AppController appController = Get.find();
  final UserController userController = Get.find();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    onWidgetBuildDone(() async {
      await userController.getAllMediaItems();
    });
  }

  @override
  void dispose() {
    userController.imagePath.value = "";
    userController.mediaItemList.clear();
    userController.imageSelectedList.clear();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHomepageBody();
  }

  _buildHomepageBody() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.padding_horizontal,
          vertical: Dimens.padding_vertical),
      child: Obx(() => appController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  _buildImagesList(),

                ],
              ),
            )),
    );
  }

  _buildShareInAlbum(){
    return GestureDetector(
      onTap: () {
        if(userController.imageSelectedList.any((item) => item['isSelected'] == true)){
          Get.to(() => const ChooseAlbumToShareScreen());
        } else {
          showAppWarningDialog(context: context, content: "You have to chose at least 1 photo");
        }
      },
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: CircleAvatar(
          backgroundColor: AppColor.lightGrey.withOpacity(0.5),
          child: const Icon(Icons.share),
        ),
      ),
    );
  }

  _buildImagesList() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  content: 'Images',
                  fontWeight: FontWeight.bold,
                  textSize: Dimens.font_size_title,
                ),
                _buildButtonAction()
              ],
            ),
            Dimens.height10,
            appController.selectingModeIsOn.value ? _buildShareInAlbum() : SizedBox(),
            Dimens.height10,
            userController.mediaItemList.isEmpty ? Center(child: AppText(content: 'No Photo Found. Please add new'),) : Wrap(
              spacing: 3.0,
              runSpacing: 3.0,
              alignment: WrapAlignment.start,
              children:
              List.generate(userController.mediaItemList.length, (index) {
                var item = userController.mediaItemList[index];
                return Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: appController.selectingModeIsOn.value
                          ? () {
                        setState(() {
                          userController.imageSelectedList[index]
                          ['isSelected'] =
                          !userController.imageSelectedList[index]
                          ['isSelected'];
                        });
                      }
                          : () => Get.to(() => ImageDetails(
                        initialIndex: index,
                      )),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.network(
                          "${item!.baseUrl}=w600-h400",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Obx(() =>
                    userController.imageSelectedList[index]['isSelected']
                        ? const Positioned(
                      bottom: 5,
                      right: 5,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColor.primary,
                        child: Icon(
                          Icons.check,
                          color: AppColor.white,
                        ),
                      ),
                    )
                        : const SizedBox())
                  ],
                );
              }),
            )
          ],
        ));
  }

  _buildButtonAction() {
    return Obx(() => appController.selectingModeIsOn.value
        ? _buildSelectModeButtons()
        : _buildUnSelectModeButtons());
  }

  _buildSelectModeButtons() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            userController.imageSelectedList.value = List.generate(userController.mediaItemList.length, (_) => {
              "id": userController.mediaItemList[_]!.id,
              "isSelected": true,
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: Dimens.padding_5, horizontal: Dimens.padding_8),
            decoration: BoxDecoration(
                color: AppColor.lightGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Dimens.circular12)),
            child: AppText(
              content: 'Select all',
              color: AppColor.black,
            ),
          ),
        ),
        Dimens.width10,
        GestureDetector(
          onTap: () async {
            appController.selectingModeIsOn.value = false;
            userController.imageSelectedList.value = List.generate(userController.mediaItemList.length, (_) => {
              "id": userController.mediaItemList[_]!.id,
              "isSelected": false,
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: Dimens.padding_5, horizontal: Dimens.padding_8),
            decoration: BoxDecoration(
                color: AppColor.lightGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Dimens.circular12)),
            child: AppText(
              content: 'Cancel',
              color: AppColor.black,
            ),
          ),
        ),
      ],
    );
  }

  _buildUnSelectModeButtons() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            appController.selectingModeIsOn.value = true;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: Dimens.padding_5, horizontal: Dimens.padding_8),
            decoration: BoxDecoration(
                color: AppColor.lightGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Dimens.circular12)),
            child: AppText(
              content: 'Select',
              color: AppColor.black,
            ),
          ),
        ),
        Dimens.width10,
        GestureDetector(
          onTap: () async {
            await userController.openGallery();
            if (userController.imagePath.value != "") {
              await userController
                  .uploadImages(userController.imagePath.value!);
              await userController.getAllMediaItems();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: Dimens.padding_5, horizontal: Dimens.padding_8),
            decoration: BoxDecoration(
                color: AppColor.lightGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Dimens.circular12)),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
