import 'package:get/get.dart';
import 'package:google_photo_app/api/user_api.dart';
import 'package:google_photo_app/services/photo_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController extends GetxController {
  Rx<GoogleSignInAccount?> user = Rx<GoogleSignInAccount?>(null);
  Rx<String?> token = Rx<String?>("");

  ///GET ALBUMS
  getAlbums() async {
    var res = await UserApi().getAlbums();
    print(res);
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
}