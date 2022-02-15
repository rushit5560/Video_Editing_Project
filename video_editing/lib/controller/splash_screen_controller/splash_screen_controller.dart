import 'dart:async';
import 'package:get/get.dart';
import 'package:video_editing/screens/login_screen/login_screen.dart';


class SplashScreenController extends GetxController {
  bool? onBoardingValue = false;
  bool? isLoggedIn = false;

  getOnBoardingValue() async {
    Get.off(()=> LoginScreen());
  }

  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 2), () => getOnBoardingValue());
  }

}