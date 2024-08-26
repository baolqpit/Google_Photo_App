import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_photo_app/controllers/app_controller.dart';
import 'package:google_photo_app/helper/bindings_helper.dart';
import 'package:google_photo_app/screens/auth_screens/log_in_screen.dart';

void main() {
  runApp(const MainScreen());
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AppController appController = Get.put<AppController>(AppController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      home: LogInScreen(),
    );
  }
}
