import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/screens/homepage/albums_screens/create_album_button.dart';
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
  void dispose() {
    // TODO: implement dispose
    userController.albumList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(
            vertical: Dimens.padding_vertical,
            horizontal: Dimens.padding_horizontal),
        child: appController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : _buildAlbumBody()));
  }

  _buildAlbumBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildTitleAndButtonsAction(), Dimens.height10, _buildAlbumsList()],
    );
  }

  _buildAlbumsList() {
    return Obx(
      () => userController.albumList.isEmpty
          ? Expanded(
              child: Center(
                child: AppText(
                  content: 'No Album Found, Create New',
                  fontWeight: FontWeight.bold,
                  textSize: Dimens.font_size_title,
                ),
              ),
            )
          : Wrap(
              spacing: 3.0,
              runSpacing: Dimens.sizeValue15,
              alignment: WrapAlignment.start,
              children: userController.albumList
                  .map((album) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                            width: 120, // Calculate width for 5 images per row
                            height: 120,
                            child: album.coverPhotoBaseUrl == ""
                                ? const Center(
                                    child: Icon(Icons.photo),
                                  )
                                : Image.network(
                                    "${album!.coverPhotoBaseUrl}=w600-h400",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                      Dimens.height5,
                      SizedBox(width: 120,child: AppText(content: album.title, maxLine: 1,)),
                      Dimens.height5,
                      AppText(content: album.mediaItemsCount == null ? "0" : album.mediaItemsCount.toString(), color: AppColor.grey,)
                    ],
                  ))
                  .toList(),
            ),
    );
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
        const CreateAlbumButton()
      ],
    );
  }
}
