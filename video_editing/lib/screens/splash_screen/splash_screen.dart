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
      // body: Stack(
      //   children: [
      //     Image.asset(
      //       Images.ic_background1,
      //       fit: BoxFit.cover,
      //     ),
      //
      //     SafeArea(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Image.asset(
      //             Images.ic_launcher,
      //             height: Get.width * 0.55,
      //             width: Get.width * 0.55,
      //           ),
      //
      //           SizedBox(height: 20,),
      //
      //           Container(
      //             child: Text("Pixy Trim", style: TextStyle(fontSize: 50, fontFamily: "Lemon Jelly"),),
      //           )
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('${Images.ic_background2}'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // height: Get.height * 0.45,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: Image.asset(Images.ic_launcher, scale: 3,),

              ),
              SizedBox(height: 20,),

              Container(
                child: Text("Video Editor", style: TextStyle(fontSize: 50, fontFamily: "Lemon Jelly"),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
