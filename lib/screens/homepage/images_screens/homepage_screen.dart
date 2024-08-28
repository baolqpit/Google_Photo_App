import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/image_controller.dart';
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
  final ImageController imageController = Get.find();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    onWidgetBuildDone(() async {
      await imageController.getAllMediaItems();
    });
  }

  @override
  void dispose() {
    imageController.imagePath.value = "";
    imageController.mediaItemList.clear();
    imageController.imageSelectedList.clear();
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

  _buildShareInAlbum() {
    return GestureDetector(
      onTap: () {
        if (imageController.imageSelectedList
            .any((item) => item['isSelected'] == true)) {
          Get.to(() => const ChooseAlbumToShareScreen());
        } else {
          showAppWarningDialog(
              context: context, content: "You have to chose at least 1 photo");
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
            appController.selectingModeIsOn.value
                ? _buildShareInAlbum()
                : SizedBox(),
            Dimens.height10,
            imageController.mediaItemList.isEmpty
                ? Center(
                    child: AppText(content: 'No Photo Found. Please add new'),
                  )
                : Wrap(
                    spacing: 3.0,
                    runSpacing: 3.0,
                    alignment: WrapAlignment.start,
                    children: List.generate(
                        imageController.mediaItemList.length, (index) {
                      var item = imageController.mediaItemList[index];
                      return Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: appController.selectingModeIsOn.value
                                ? () {
                                    setState(() {
                                      imageController.imageSelectedList[index]
                                          ['isSelected'] = !imageController
                                              .imageSelectedList[index]
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
                          Obx(() => imageController.imageSelectedList[index]
                                  ['isSelected']
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
            imageController.imageSelectedList.value = List.generate(
                imageController.mediaItemList.length,
                (_) => {
                      "id": imageController.mediaItemList[_]!.id,
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
            imageController.imageSelectedList.value = List.generate(
                imageController.mediaItemList.length,
                (_) => {
                      "id": imageController.mediaItemList[_]!.id,
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
            await imageController.openGallery();
            if (imageController.imagePath.value != "") {
              await imageController
                  .uploadImages(imageController.imagePath.value!);
              await imageController.getAllMediaItems();
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
