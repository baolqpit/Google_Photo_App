import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? title;
  bool showReturnButton;
  final double borderRadius; // Added to control corner radius

  CustomAppBar({super.key,
    required this.title,
    required this.showReturnButton,
    this.borderRadius = 16.0, // Default corner radius
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.padding_horizontal, vertical: Dimens.padding_vertical),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showReturnButton
                ? IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.primary),
            )
                : const SizedBox(),
            Expanded(
              child: Center(
                child: AppText(
                  content: title ?? "",
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                  textSize: Dimens.font_size_title,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}