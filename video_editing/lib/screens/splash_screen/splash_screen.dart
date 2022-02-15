import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_editing/common/common_widgets.dart';
import 'package:video_editing/common/image_url.dart';
import 'package:video_editing/controller/splash_screen_controller/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  final splashScreenController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MainBackgroundWidget(),

          SafeArea(
            child: Center(
              child: Image.asset(
                Images.ic_launcher,
                height: Get.width * 0.55,
                width: Get.width * 0.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
