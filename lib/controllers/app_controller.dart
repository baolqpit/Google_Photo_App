import 'package:get/get.dart';

class AppController extends GetxController {
  Rx<int?> currentBottomIndex = Rx<int?>(0);
  Rx<int?> currentImageDetailBottomIndex = Rx<int?>(0);
  Rx<bool> isLoading = Rx<bool>(false);
  Rx<bool> selectingModeIsOn = Rx<bool>(false);


}