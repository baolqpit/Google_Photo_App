import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/image_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/models/media_item/media_item.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/widgets/custom_app_bar.dart';
import 'package:google_photo_app/share/widgets/dialogs.dart';

class ImageDetails extends StatefulWidget {
  final int initialIndex;
  const ImageDetails({super.key,required this.initialIndex});

  @override
  State<ImageDetails> createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {
  final UserController userController = Get.find();
  final AppController appController = Get.find();
  final ImageController imageController = Get.find();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    imageController.mediaItemIndex.value = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    imageController.mediaItemIndex.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: CustomAppBar(title: '', showReturnButton: true),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (index){
                imageController.mediaItemIndex.value = index;
                print(imageController.mediaItemIndex.value);
              },
              controller: _pageController,
              itemCount: imageController.mediaItemList.length,
              itemBuilder: (context, index) {
                return Center(
                  child: SizedBox(
                    width: Get.width,
                    height: 500,
                    child: Image.network(
                      "${imageController.mediaItemList[index]!.baseUrl}=w600-h400",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }

}
