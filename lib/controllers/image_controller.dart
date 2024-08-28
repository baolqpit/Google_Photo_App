import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/models/media_item/media_item.dart';
import 'package:google_photo_app/services/photo_service.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  final AppController appController = Get.find();
  final UserController userController = Get.find();
  Rx<String?> imagePath = Rx<String?>("");
  RxList<MediaItem?> mediaItemList = RxList<MediaItem?>([]);
  RxList<dynamic> imageSelectedList = RxList([]);
  Rx<int?> mediaItemIndex = Rx<int?>(null);

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
    final uploadToken = await PhotoService().uploadImagesToGooglePhotos(filePath: filePath, accessToken: userController.token.value!);
    if (uploadToken == null){
      print("Image upload failed");
      return;
    }
    await PhotoService().createMediaItems(uploadToken: uploadToken, accessToken: userController.token.value!);
    appController.isLoading.value = false;
  }

  ///GET ALL MEDIA ITEMS
  getAllMediaItems() async{
    appController.isLoading.value = true;
    var res = await PhotoService().getMediaItems(accessToken: userController.token.value!);
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