import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_editing/common/common_widgets.dart';
import 'package:video_editing/controller/home_screen_controller/home_screen_controller.dart';

import 'home_screen_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          MainBackgroundWidget(),

          SafeArea(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HeaderTextModule(),
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          VideoEditModule(),
                          const SizedBox(height: 5),
                          CompressVideoFromGalleryModule(),
                          const SizedBox(height: 5),
                          CompressVideoFromCameraModule(),
                          const SizedBox(height: 5),
                          AddMusicModule(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(),


                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
