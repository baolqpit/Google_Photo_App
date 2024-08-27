import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_photo_app/api/user_api.dart';
import 'package:google_photo_app/models/media_item/media_item.dart';
import 'package:google_photo_app/services/photo_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  Rx<GoogleSignInAccount?> user = Rx<GoogleSignInAccount?>(null);
  Rx<String?> token = Rx<String?>("");
  Rx<String?> imagePath = Rx<String?>("");
  RxList<MediaItem?> mediaItemList = RxList<MediaItem?>([]);
  RxList<dynamic?> listImgUrl = RxList<dynamic?>([]);

  ///GET ALBUMS
  getAlbums() async {
    var res = await UserApi().getAlbums();
    print(res);
  }

  ///OPEN GALLERY
  openGallery() async{
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null){
      imagePath.value = image.path;
      print(imagePath.value);
    }
  }

  ///UPLOAD IMAGES
  uploadImages(String filePath) async {
    final uploadToken = await PhotoService().uploadImagesToGooglePhotos(filePath: filePath, accessToken: token.value!);
    if (uploadToken == null){
      print("Image upload failed");
      return;
    }
    await PhotoService().createMediaItems(uploadToken: uploadToken, accessToken: token.value!);
  }

  ///GET ALL MEDIA ITEMS
  getAllMediaItems() async{
    var res = await PhotoService().getMediaItems(accessToken: token.value!);
    if (res != null){
      mediaItemList.value = res.map<MediaItem>((json) => MediaItem.fromJson(json)).toList();
    }
  }
}