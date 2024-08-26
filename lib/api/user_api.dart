import 'package:get/get.dart';
import 'package:google_photo_app/api/base_api.dart';
import 'package:google_photo_app/controllers/user_controller.dart';

class UserApi extends BaseApi{
  final UserController userController = Get.find();
  UserApi() : super();
  final GET_LIST_ALBUMN = 'albums';

  getAlbums(){
    return BaseApi().getAppDataFromAPI(url: GET_LIST_ALBUMN, token: userController.token.value!);
  }
}