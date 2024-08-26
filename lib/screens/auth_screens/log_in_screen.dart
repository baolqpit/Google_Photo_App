import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/user_controller.dart';
import 'package:google_photo_app/screens/homepage/homepage_screen.dart';
import 'package:google_photo_app/services/auth_service.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';
import 'package:google_photo_app/share/images/images.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    return Scaffold(
      body: Container(
        width: Get.width,
        color: AppColor.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.padding_horizontal, vertical: Dimens.padding_vertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppText(
                content: 'Photo App',
                color: AppColor.white,
                textSize: Dimens.font_size_max,
              ),
              Dimens.height5,
              CircleAvatar(
                  radius: 100,
                  child: Image.asset(
                    Images.photo_logo_png,
                  )),
              Dimens.height10,
              AppText(content: 'This application allows you to manage your photos effortlessly. You can view, upload, and delete any image with ease.', color: AppColor.white, fontStyle: FontStyle.italic,),
              Dimens.height10,
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.white, // Change background color if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Optional: make the button rounded
                    ),
                  ),
                  onPressed: () async {
                    GoogleSignInAccount? res = await GoogleAuthService().signInWithGoogle();
                    if (res != null){
                      userController.user.value = res;
                      GoogleSignInAuthentication auth = await res.authentication;
                      userController.token.value = auth.accessToken ?? "";
                      print("Token: ${userController.token.value}");
                      Get.to(() => const HomepageScreen());
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        Images.google_icon,
                        width: 30,
                        height: 30,
                      ),
                      Dimens.width10,
                      AppText(content: 'Sign in with Google'),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
