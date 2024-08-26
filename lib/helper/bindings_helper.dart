import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    print('Initial Controller');
    Get.put<UserController>(UserController());
    // TODO: implement dependencies
  }

}