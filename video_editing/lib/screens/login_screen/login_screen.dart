import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_editing/common/common_widgets.dart';
import 'package:video_editing/controller/login_screen_controller/login_screen_controller.dart';

import 'login_screen_widgets.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final loginScreenController = Get.put(LoginScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MainBackgroundWidget(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    WelcomeTextModule(),

                    SocialLogin(),
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
