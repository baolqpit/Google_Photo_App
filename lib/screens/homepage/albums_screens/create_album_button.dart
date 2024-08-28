import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/album_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';
import 'package:google_photo_app/share/widgets/dialogs.dart';

class CreateAlbumButton extends StatefulWidget {
  const CreateAlbumButton({super.key});

  @override
  State<CreateAlbumButton> createState() => _CreateAlbumButtonState();
}

class _CreateAlbumButtonState extends State<CreateAlbumButton> {
  final UserController userController = Get.find();
  final AlbumController albumController = Get.find();
  TextEditingController albumNameController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    albumController.albumList.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return showAlertDialog(
                  title: "Create New Album",
                  context: context,
                  onSubmitFunction: () async {
                    await userController.createAlbum(albumTitle: albumNameController.text);
                    await albumController.getAlbums();
                    Get.back();
                  },
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppText(
                          content: "Album's Name", fontWeight: FontWeight.bold),
                      Dimens.height5,
                      Container(
                        padding: const EdgeInsets.all(Dimens.padding_8),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimens.circular12),
                            border: const Border.fromBorderSide(
                                BorderSide(color: AppColor.black, width: 2.0))),
                        child: TextField(
                          controller: albumNameController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Album 1'),
                        ),
                      )
                    ],
                  ));
            });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: Dimens.padding_5, horizontal: Dimens.padding_8),
        decoration: BoxDecoration(
            color: AppColor.lightGrey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimens.circular12)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
