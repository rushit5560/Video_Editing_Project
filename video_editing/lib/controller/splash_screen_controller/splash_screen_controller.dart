import 'dart:async';

import 'package:get/get.dart';
import 'package:video_editing/screens/home_screen/home_screen_new.dart';

class SplashScreenController extends GetxController {
  bool? onBoardingValue = false;
  bool? isLoggedIn = false;

  getOnBoardingValue() async {
    Get.off(()=> HomeScreen());
  }

  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 2), () => getOnBoardingValue());
  }

}