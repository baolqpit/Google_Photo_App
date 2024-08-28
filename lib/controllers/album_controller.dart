import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/image_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/models/album_model/album_model.dart';
import 'package:google_photo_app/models/media_item/media_item.dart';
import 'package:google_photo_app/services/album_service.dart';

class AlbumController extends GetxController {
  final AppController appController = Get.find();
  final UserController userController = Get.find();
  final ImageController imageController = Get.find();
  RxList<MediaItem?> mediaItemListInAlbum = RxList<MediaItem?>([]);
  RxList<AlbumModel> albumList = RxList<AlbumModel>([]);


  ///GET PHOTOS IN ALBUM
  getPhotosInAlbum({required String albumId}) async {
    appController.isLoading.value = true;
    var res = await AlbumService().getMediaItemsInAlbum(accessToken: userController.token.value!, albumId: albumId);
    if (res != null){
      mediaItemListInAlbum.value = res.map((json) => MediaItem.fromJson(json)).toList();
    }
    appController.isLoading.value = false;
  }

  ///ADD ITEMS TO ALBUM
  addItemsToAlbum({required String albumId}) async {
    appController.isLoading.value = true;
    List<String> listMediaItemId = imageController.imageSelectedList.where((image) => image['isSelected'] == true).map<String>((image) => image['id']).toList();
    await AlbumService().addingMediaItemsToAnAlbum(listMediaItemId: listMediaItemId, albumId: albumId, accessToken: userController.token.value!);
    appController.isLoading.value = false;
  }

  ///GET ALBUMS
  getAlbums() async {
    appController.isLoading.value = true;
    var res = await AlbumService().getAlbums(accessToken: userController.token.value!);
    if(res != null){
      albumList.value = res.map<AlbumModel>((json) => AlbumModel.fromJson(json)).toList();
    }
    appController.isLoading.value = false;
  }

  ///CREATE ALBUM
  createAlbum({required String albumTitle}) async {
    appController.isLoading.value = true;
    await AlbumService().createAlbum(accessToken: userController.token.value!, albumTitle: albumTitle);
    appController.isLoading.value = false;
  }
}