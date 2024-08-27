import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/app_general/app_text.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';

/// WARNING DIALOG
showAppWarningDialog({required BuildContext context, required String content}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            Center(
                child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary),
                    child: AppText(
                      content: 'Okay',
                      color: AppColor.white,
                    )))
          ],
          content: AppText(content: content),
          title: Center(
              child: AppText(
                content: 'WARNING',
                color: AppColor.amber,
                fontWeight: FontWeight.bold,
                textSize: Dimens.font_size_title,
              )),
        );
      });
}

///ERROR DIALOG
showAppErrorDialog({required BuildContext context, required String content}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            Center(
                child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary),
                    child: AppText(
                      content: 'Okay',
                      color: AppColor.white,
                    )))
          ],
          content: AppText(content: content),
          title: Center(
              child: AppText(
                content: 'ERROR',
                color: AppColor.red,
                fontWeight: FontWeight.bold,
                textSize: Dimens.font_size_title,
              )),
        );
      });
}

///SNACKBAR
showSnackBar({required BuildContext context, required String content}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    padding: const EdgeInsets.all(Dimens.padding_8),
    backgroundColor: AppColor.primary,
    content: AppText(content: content),
  ));
}

///SHOW ALERT DIALOG
showAlertDialog({required BuildContext context, String? title, required Function()? onSubmitFunction, required Widget widget}){
  return AlertDialog(
    title: Center(
        child: AppText(
          content: title ?? "",
          fontWeight: FontWeight.bold,
          textSize: Dimens.font_size_title,
        )),
    content: IntrinsicHeight(
        child: widget
    ),
    actions: <Widget>[
      ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.cancelColor),
          onPressed: () => Get.back(),
          child: AppText(content: 'Cancel', color: AppColor.white, fontWeight: FontWeight.bold,)),
      ElevatedButton(
        onPressed: onSubmitFunction,
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.submitColor),
        child: AppText(
          content: 'Okay',
          color: AppColor.white,
          fontWeight: FontWeight.bold,
        ),
      )
    ],
  );
}