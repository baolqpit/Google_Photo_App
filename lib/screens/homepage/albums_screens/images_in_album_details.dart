import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/album_controller.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/image_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/models/media_item/media_item.dart';
import 'package:google_photo_app/share/widgets/custom_app_bar.dart';

class ImagesInAlbumDetails extends StatefulWidget {
  final int initialIndex;
  const ImagesInAlbumDetails({super.key, required this.initialIndex});

  @override
  State<ImagesInAlbumDetails> createState() => _ImagesInAlbumDetailsState();
}

class _ImagesInAlbumDetailsState extends State<ImagesInAlbumDetails> {
  final UserController userController = Get.find();
  final AppController appController = Get.find();
  // final ImageController imageController = Get.find();
  final AlbumController albumController = Get.find();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    albumController.mediaItemIndex.value = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    albumController.mediaItemIndex.value = null;
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
                  onPageChanged: (index) {
                    albumController.mediaItemIndex.value = index;
                    print(albumController.mediaItemIndex.value);
                  },
                  controller: _pageController,
                  itemCount: albumController.mediaItemListInAlbum.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: SizedBox(
                        width: Get.width,
                        height: 500,
                        child: Image.network(
                          "${albumController.mediaItemListInAlbum[index]!.baseUrl}=w600-h400",
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
