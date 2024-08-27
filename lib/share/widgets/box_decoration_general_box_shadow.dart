import 'package:flutter/material.dart';
import 'package:google_photo_app/share/app_general/app_color.dart';
import 'package:google_photo_app/share/dimens/dimens.dart';

class BoxDecorationGeneralBoxShadow extends StatefulWidget {
  const BoxDecorationGeneralBoxShadow({super.key});

  @override
  State<BoxDecorationGeneralBoxShadow> createState() => _BoxDecorationGeneralBoxShadowState();
}

class _BoxDecorationGeneralBoxShadowState extends State<BoxDecorationGeneralBoxShadow> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.circular12),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(3, 3),
              ),
            ]),
      ),
    );
  }
}
