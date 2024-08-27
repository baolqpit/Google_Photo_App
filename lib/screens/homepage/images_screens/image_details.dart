import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    userController.mediaItemIndex.value = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    userController.mediaItemIndex.value = null;
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
                userController.mediaItemIndex.value = index;
                print(userController.mediaItemIndex.value);
              },
              controller: _pageController,
              itemCount: userController.mediaItemList.length,
              itemBuilder: (context, index) {
                return Center(
                  child: SizedBox(
                    width: Get.width,
                    height: 500,
                    child: Image.network(
                      "${userController.mediaItemList[index]!.baseUrl}=w600-h400",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: _buildButtonsAction(mediaItem: userController.mediaItemList[userController.mediaItemIndex.value!]!),
          ),
        ],
      ),
    ));
  }

  _buildButtonsAction({required MediaItem mediaItem}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildFavouriteButton(),
        _buildDeleteButton(mediaItem: mediaItem),
      ],
    );
  }

  _buildFavouriteButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.favorite_outline),
      iconSize: 40,
    );
  }

  _buildDeleteButton({required MediaItem mediaItem}) {
    return IconButton(
      onPressed: () {
        showDialog(context: context, builder: (context){
          return showAlertDialog(title: "Confirm delete photo" ,context: context, onSubmitFunction: (){ Get.back();
          }, widget: AppText(content: 'I found that Google Photo API does not support this feature, so I skip the delete feature'));
        });
      },
      icon: const Icon(Icons.delete_outlined),
      iconSize: 40,
    );
  }
}
