import 'package:get/get.dart';
import 'package:google_photo_app/controllers/album_controller.dart';

import '../controllers/user_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    print('Initial Controller');
    Get.put<UserController>(UserController());
    Get.put<AlbumController>(AlbumController());
    // TODO: implement dependencies
  }

}