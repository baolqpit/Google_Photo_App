import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/album_controller.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/image_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';
import 'package:google_photo_app/share/functions/functions.dart';
import 'package:google_photo_app/share/widgets/box_decoration_general_box_shadow.dart';
import 'package:google_photo_app/share/widgets/custom_app_bar.dart';
import 'package:google_photo_app/share/widgets/dialogs.dart';

class ChooseAlbumToShareScreen extends StatefulWidget {
  const ChooseAlbumToShareScreen({super.key});

  @override
  State<ChooseAlbumToShareScreen> createState() =>
      _ChooseAlbumToShareScreenState();
}

class _ChooseAlbumToShareScreenState extends State<ChooseAlbumToShareScreen> {
  final UserController userController = Get.find();
  final AppController appController = Get.find();
  final ImageController imageController = Get.find();
  final AlbumController albumController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    onWidgetBuildDone(() async => await albumController.getAlbums());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    albumController.albumList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showReturnButton: true),
      body: _buildShareAlbumBody(),
    );
  }

  _buildShareAlbumBody() {
    return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: Dimens.padding_vertical,
            horizontal: Dimens.padding_horizontal),
        child: Obx(() => appController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(
                    content: 'List Albums',
                    fontWeight: FontWeight.bold,
                    textSize: Dimens.font_size_title,
                  ),
                  Dimens.height10,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: albumController.albumList
                          .map((album) => GestureDetector(
                        onTap: () {
                          showDialog(context: context, builder: (context){
                            return showAlertDialog(context: context, onSubmitFunction: () async {
                              await albumController.addItemsToAlbum(albumId: album.id!);
                              await albumController.getAlbums();
                              Get.back();
                            }, title: 'Album ${album.title}', widget: AppText(content: 'Add ${countNumberOfPhotosToAdd()} photos to this album'));
                          });
                        },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 120,
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
                                      SizedBox(width: 120,child: AppText(content: album.title, maxLine: 1,)),
                                    ],
                                  ),
                            ),
                          ))
                          .toList(),
                    ),
                  )
                ],
              )));
  }

  countNumberOfPhotosToAdd(){
    int numberOfPhotos = 0;
    imageController.imageSelectedList.forEach((item) {
      if (item['isSelected']){
        numberOfPhotos++;
      }
    });
    return numberOfPhotos;
  }
}
