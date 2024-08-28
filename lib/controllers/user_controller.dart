import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/models/album_model/album_model.dart';
import 'package:google_photo_app/models/media_item/media_item.dart';
import 'package:google_photo_app/services/album_service.dart';
import 'package:google_photo_app/services/photo_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  final AppController appController = Get.find();
  Rx<GoogleSignInAccount?> user = Rx<GoogleSignInAccount?>(null);
  Rx<String?> token = Rx<String?>("");
  Rx<String?> imagePath = Rx<String?>("");
  RxList<MediaItem?> mediaItemList = RxList<MediaItem?>([]);
  RxList<AlbumModel> albumList = RxList<AlbumModel>([]);
  RxList<dynamic> imageSelectedList = RxList([]);
  Rx<int?> mediaItemIndex = Rx<int?>(null);

  ///GET ALBUMS
  getAlbums() async {
    appController.isLoading.value = true;
    var res = await AlbumService().getAlbums(accessToken: token.value!);
    if(res != null){
      albumList.value = res.map<AlbumModel>((json) => AlbumModel.fromJson(json)).toList();
    }
    appController.isLoading.value = false;

  }

  ///CREATE ALBUM
  createAlbum({required String albumTitle}) async {
    appController.isLoading.value = true;
    await AlbumService().createAlbum(accessToken: token.value!, albumTitle: albumTitle);
    appController.isLoading.value = false;
  }

  ///OPEN GALLERY
  openGallery() async {
    appController.isLoading.value = true;
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null){
      imagePath.value = image.path;
      print(imagePath.value);
    }
    appController.isLoading.value = false;
  }

  ///UPLOAD IMAGES
  uploadImages(String filePath) async {
    appController.isLoading.value = true;
    final uploadToken = await PhotoService().uploadImagesToGooglePhotos(filePath: filePath, accessToken: token.value!);
    if (uploadToken == null){
      print("Image upload failed");
      return;
    }
    await PhotoService().createMediaItems(uploadToken: uploadToken, accessToken: token.value!);
    appController.isLoading.value = false;
  }

  ///GET ALL MEDIA ITEMS
  getAllMediaItems() async{
    appController.isLoading.value = true;
    var res = await PhotoService().getMediaItems(accessToken: token.value!);
    if (res != null){
      mediaItemList.value = res.map<MediaItem>((json) => MediaItem.fromJson(json)).toList();
      imageSelectedList.value = List.generate(mediaItemList.length, (_) =>
      {
        'id': mediaItemList[_]!.id,
        'isSelected': false
      });
    }
    appController.isLoading.value = false;
  }
}