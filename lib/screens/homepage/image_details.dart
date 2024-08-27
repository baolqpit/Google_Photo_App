import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/models/media_item/media_item.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';
import 'package:google_photo_app/share/widgets/custom_app_bar.dart';

class ImageDetails extends StatefulWidget {
  final int initialIndex;
  const ImageDetails({super.key,required this.initialIndex});

  @override
  State<ImageDetails> createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {
  final AppController appController = Get.find();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    return Scaffold(
      appBar: CustomAppBar(title: '', showReturnButton: true),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
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
            child: _buildButtonsAction(),
          ),
        ],
      ),
    );
  }

  _buildButtonsAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildFavouriteButton(),
        _buildDeleteButton(),
      ],
    );
  }

  _buildFavouriteButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.favorite_outline),
      iconSize: 40,
    );
  }

  _buildDeleteButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.delete_outlined),
      iconSize: 40,
    );
  }
}
