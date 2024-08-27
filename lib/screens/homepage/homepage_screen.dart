import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/screens/homepage/image_details.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';
import 'package:google_photo_app/share/functions/functions.dart';

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
      child: Obx(() => appController.isLoading.value ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            _buildImagesList(),
            // _buildButtonAction()
          ],
        ),
      )),
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
            Wrap(
              spacing: 3.0,
              runSpacing: 3.0,
              alignment: WrapAlignment.start,
              children: userController.mediaItemList
                  .map((item) => GestureDetector(
                        onTap: () => Get.to(() => ImageDetails(initialIndex: userController.mediaItemList.indexOf(item),)),
                        child: SizedBox(
                          width: 120, // Calculate width for 5 images per row
                          height: 120,
                          child: Image.network(
                            "${item!.baseUrl}=w600-h400",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ));
  }

  _buildButtonAction() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: Dimens.padding_5, horizontal: Dimens.padding_8),
          decoration: BoxDecoration(
            color: AppColor.lightGrey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimens.circular12)
          ),
          child: AppText(content: 'Select', color: AppColor.black,),
        ),
        Dimens.width10,
        GestureDetector(
          onTap: () async {
            await userController.openGallery();
            if (userController.imagePath.value != "") {
              await userController.uploadImages(userController.imagePath.value!);
              await userController.getAllMediaItems();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Dimens.padding_5, horizontal: Dimens.padding_8),
            decoration: BoxDecoration(
                color: AppColor.lightGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Dimens.circular12)
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
