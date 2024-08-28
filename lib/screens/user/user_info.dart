import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/screens/auth_screens/log_in_screen.dart';
import 'package:google_photo_app/services/auth_service.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';
import 'package:google_photo_app/share/widgets/box_decoration_general_box_shadow.dart';
import 'package:google_photo_app/share/widgets/custom_app_bar.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showReturnButton: true),
      body: _buildUserInfoBody(),
    );
  }

  _buildUserInfoBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimens.padding_vertical,
          horizontal: Dimens.padding_horizontal),
      child: Column(
        children: <Widget>[
          _buildSignOut(),
        ],
      ),
    );
  }

  _buildSignOut() {
    return Stack(
      children: <Widget>[
        const BoxDecorationGeneralBoxShadow(),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.padding_horizontal,
              vertical: Dimens.padding_vertical),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.circular12),
              color: AppColor.white),
          child: GestureDetector(
            onTap: () async {
              await GoogleAuthService().signOutGoogle();
              Get.offAll(() => const LogInScreen());
    } ,
            child: Row(
              children: <Widget>[
                const Icon(Icons.logout),
                Dimens.width10,
                AppText(content: 'Sign Out')
              ],
            ),
          ),
        )
      ],
    );
  }
}
