import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/album_controller.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/models/album_model/album_model.dart';
import 'package:google_photo_app/screens/homepage/albums_screens/images_in_album_details.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';
import 'package:google_photo_app/share/functions/functions.dart';
import 'package:google_photo_app/share/widgets/custom_app_bar.dart';
import 'package:google_photo_app/share/widgets/dialogs.dart';

class AlbumDetails extends StatefulWidget {
  final AlbumModel album;
  const AlbumDetails({super.key, required this.album});

  @override
  State<AlbumDetails> createState() => _AlbumDetailsState();
}

class _AlbumDetailsState extends State<AlbumDetails> {
  final AppController appController = Get.find();
  final UserController userController = Get.find();
  final AlbumController albumController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    onWidgetBuildDone(() async {
      await albumController.getAlbums();
      await albumController.getPhotosInAlbum(albumId: widget.album.id!);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    albumController.mediaItemListInAlbum.clear();
    albumController.mediaSelectedInAlbum.clear();
    albumController.selectingModeIsOn.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: CustomAppBar(title: '', showReturnButton: true),
          body: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimens.padding_vertical,
                  horizontal: Dimens.padding_horizontal),
              child: appController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildActionButtons(),
                        Dimens.height10,
                        albumController.selectingModeIsOn.value ? _buildDeleteButton() : SizedBox(),
                        Dimens.height10,
                        _buildImagesList(),
                      ],
                    )),
        ));
  }

  _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AppText(
          content: 'Images',
          fontWeight: FontWeight.bold,
          textSize: Dimens.font_size_title,
        ),
        albumController.selectingModeIsOn.value
            ? _buildButtonsOnSelected()
            : GestureDetector(
                onTap: () {
                  albumController.selectingModeIsOn.value = true;
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimens.padding_5,
                        horizontal: Dimens.padding_8),
                    decoration: BoxDecoration(
                        color: AppColor.lightGrey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(Dimens.circular12)),
                    child: AppText(
                      content: 'Select',
                    )),
              )
      ],
    );
  }

  _buildButtonsOnSelected() {
    return Row(
      children: <Widget>[
        _buildSelectAll(),
        Dimens.width5,
        _buildCancelButton()
      ],
    );
  }
  
  _buildDeleteButton(){
    return GestureDetector(
      onTap: () {
        if (albumController.mediaSelectedInAlbum
            .any((item) => item['isSelected'] == true)) {
          showDialog(context: context, builder: (context){
            return showAlertDialog(context: context, onSubmitFunction: () async {
              await albumController.removeItemsFromAlbum(albumId: widget.album.id!);
              await albumController.getPhotosInAlbum(albumId: widget.album.id!);
              await albumController.getAlbums();
              Get.back();
            }, widget: AppText(content: 'Are you sure to remove these items from this album?'), title: 'Confirm Remove');
          });
        } else {
          showAppWarningDialog(
              context: context, content: "You have to chose at least 1 photo");
        }
      },
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: Dimens.padding_5, horizontal: Dimens.padding_8),
          decoration: BoxDecoration(
              color: AppColor.lightGrey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(Dimens.circular12)
          ),
          child: const Icon(Icons.delete_outlined),
        ),
      ),
    );
  }

  _buildSelectAll() {
    return GestureDetector(
      onTap: () {
        albumController.mediaSelectedInAlbum.value = List.generate(
            albumController.mediaItemListInAlbum.length,
                (_) => {
              "id": albumController.mediaItemListInAlbum[_]!.id,
              "isSelected": true,
            });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: Dimens.padding_5, horizontal: Dimens.padding_8),
        decoration: BoxDecoration(
          color: AppColor.lightGrey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimens.circular12)
        ),
        child: AppText(content: 'Select All'),
      ),
    );
  }

  _buildCancelButton() {
    return GestureDetector(
      onTap: () {
        albumController.selectingModeIsOn.value = !albumController.selectingModeIsOn.value;
        albumController.mediaSelectedInAlbum.value = List.generate(
            albumController.mediaItemListInAlbum.length,
                (_) => {
              "id": albumController.mediaItemListInAlbum[_]!.id,
              "isSelected": false,
            });
      },
      child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: Dimens.padding_5, horizontal: Dimens.padding_8),
          decoration: BoxDecoration(
            color: AppColor.lightGrey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(Dimens.circular12)
          ),
        child: AppText(content: "Cancel"),
          ),
    );
  }

  _buildImagesList() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: 3.0,
          runSpacing: 3.0,
          alignment: WrapAlignment.start,
          children: List.generate(albumController.mediaItemListInAlbum.length,
              (index) {
            var item = albumController.mediaItemListInAlbum[index];
            return Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: albumController.selectingModeIsOn.value ? () {
                    setState(() {
                      albumController.mediaSelectedInAlbum[index]
                      ['isSelected'] = !albumController
                          .mediaSelectedInAlbum[index]
                      ['isSelected'];
                    });
                  } : () {
                    Get.to(() => ImagesInAlbumDetails(initialIndex: index));
                  },
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.network(
                      "${item!.baseUrl}=w600-h400",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Obx(() => albumController.mediaSelectedInAlbum[index]
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
        ),
      ),
    );
  }
}
