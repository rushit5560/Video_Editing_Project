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
            child: Padding(
              padding: Margin.all(30),
              child: Column(
                children: [
                  cropScreenAppbarModule(context),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              controller.rotate90Degrees(RotateDirection.left),
                          child: Icon(Icons.rotate_left),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              controller.rotate90Degrees(RotateDirection.right),
                          child: Icon(Icons.rotate_right),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: AnimatedInteractiveViewer(
                      maxScale: 2.4,
                      child: CropGridViewer(
                        controller: controller, /*horizontalMargin: 60*/
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      buildSplashTap("16:9", 16 / 9,
                          padding: Margin.horizontal(10)),
                      buildSplashTap("1:1", 1 / 1),
                      buildSplashTap("4:5", 4 / 5,
                          padding: Margin.horizontal(10)),
                      buildSplashTap("NO", null, padding: Margin.right(10)),
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




  Widget cropScreenAppbarModule(BuildContext context) {
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
                onTap: () => controller.updateCrop(),
                child: Container(
                  child: Icon(Icons.check_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
