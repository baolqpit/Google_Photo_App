import 'package:get/get.dart';
import 'package:google_photo_app/api/user_api.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController extends GetxController {
  Rx<GoogleSignInAccount?> user = Rx<GoogleSignInAccount?>(null);
  Rx<String?> token = Rx<String?>("");

  ///GET ALBUMS
  getAlbums() async {
    var res = await UserApi().getAlbums();
    print(res);
  }
}