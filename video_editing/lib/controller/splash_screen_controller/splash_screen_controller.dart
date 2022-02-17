import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_editing/screens/home_screen/home_screen_new.dart';
import 'package:video_editing/screens/login_screen/login_screen.dart';
import 'package:video_editing/screens/onboarding_screen/onboarding_screen.dart';


class SplashScreenController extends GetxController {
  bool? onBoardingValue = false;
  bool? isLoggedIn = false;
  String userId = "";

  getOnBoardingValue() async {
    //Get.off(()=> LoginScreen());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    onBoardingValue = prefs.getBool("onboarding") ?? false;
    userId = prefs.getString('userId') ?? '';


    if(onBoardingValue == true) {
      //Get.off(() => LoginScreen());
      if(userId.isNotEmpty){
        Get.off(() => HomeScreen());
      } else{
        Get.off(() => LoginScreen());
      }
    }
    else{
      Get.off(() => OnBoardingScreen());
    }
  }

  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 3), () => getOnBoardingValue());
  }

}