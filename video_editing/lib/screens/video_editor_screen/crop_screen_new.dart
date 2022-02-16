import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:video_editing/common/common_widgets.dart';
import 'package:video_editing/common/image_url.dart';
import 'package:video_editor/video_editor.dart';

class CropScreenNew extends StatelessWidget {
  final VideoEditorController controller;
  const CropScreenNew({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MainBackgroundWidget(),

          SafeArea(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  appBar(),

                  SizedBox(height: 15),
                  Expanded(
                    child: AnimatedInteractiveViewer(
                      maxScale: 2.4,
                      child: Container(
                       // color: Colors.yellow,
                        child: CropGridViewer(
                          controller: controller, /*horizontalMargin: 60*/

                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            controller.rotate90Degrees(RotateDirection.left),
                        child: Container(
                          width: 50,height: 50,
                          decoration: borderGradientDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: containerBackgroundGradient(),
                                child: Icon(Icons.rotate_left)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            controller.rotate90Degrees(RotateDirection.right),
                        child: Container(
                          width: 50,height: 50,
                          decoration: borderGradientDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: containerBackgroundGradient(),
                                child: Icon(Icons.rotate_right)),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /*Expanded(
                        child: SplashTap(
                          onTap: context.goBack,
                          child: Center(
                            child: TextDesigned(
                              "CANCEL",
                              bold: true,
                            ),
                          ),
                        ),
                      ),*/
                      buildSplashTap("3:4", 3 / 4,),
                      buildSplashTap("16:9", 16 / 9),
                      buildSplashTap("1:1", 1 / 1),
                      buildSplashTap("2:3", 2 / 3),
                      buildSplashTap("4:5", 4 / 5),
                      //buildSplashTap("NO", null, padding: Margin.right(10)),
                      /*Expanded(
                        child: SplashTap(
                          onTap: () {
                            //2 WAYS TO UPDATE CROP
                            //WAY 1:
                            controller.updateCrop();
                            *//*WAY 2:
                    controller.minCrop = controller.cacheMinCrop;
                    controller.maxCrop = controller.cacheMaxCrop;
                    *//*
                            context.goBack();
                          },
                          child: Center(
                            child: TextDesigned("OK", bold: true),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSplashTap(
      String title,
      double? aspectRatio, {
        EdgeInsetsGeometry? padding,
      }) {
    return SplashTap(
      onTap: () => controller.preferredCropAspectRatio = aspectRatio,
      child: Padding(
        padding: padding ?? Margin.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.aspect_ratio, color: Colors.black),
            TextDesigned(title, bold: true),
          ],
        ),
      ),
    );
  }




 /* Widget cropScreenAppbarModule(BuildContext context) {
    return Container(
      height: 50,
      width: Get.width,
      decoration: borderGradientDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.goBack,
                child: Container(
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
              Container(
                child: Text(
                  "Crop Video",
                  style: TextStyle(
                      fontFamily: "",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  controller.updateCrop();
                  Get.back();
                  //context.goBack();
                },
                child: Container(
                  child: Icon(Icons.check_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }*/

  Widget appBar() {
    return Container(
      height: 50,
      width: Get.width,
      decoration: borderGradientDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: containerBackgroundGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    //showAlertDialog();
                  },
                  child: Container(
                      child: Image.asset(
                        Images.ic_left_arrow,
                        scale: 2.5,
                      )),
                ),
                Container(
                  child: Text(
                    "Crop Video",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.updateCrop();
                    Get.back();
                    //context.goBack();
                  },
                  child: Container(
                    child: Icon(Icons.check_rounded),
                  ),
                ),
              ],
            )),
      ),
    );
  }


}
