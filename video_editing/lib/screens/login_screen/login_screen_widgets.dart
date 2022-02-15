import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:video_editing/common/common_widgets.dart';
import 'package:video_editing/common/image_url.dart';
import 'package:video_editing/controller/login_screen_controller/login_screen_controller.dart';
import 'package:video_editing/screens/home_screen/home_screen_new.dart';

class WelcomeTextModule extends StatelessWidget {
  const WelcomeTextModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Image.asset(Images.ic_launcher, scale: 5),
        ),
        SizedBox(height: 15,),
        Container(
          alignment: Alignment.center,
          child: Text(
            "Welcome to Video Editor",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontFamily: "Lemon Jelly",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class SocialLogin extends StatelessWidget {
  SocialLogin({Key? key}) : super(key: key);
  final loginScreenController = Get.find<LoginScreenController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            loginScreenController.googleAuthentication(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              height: 60,
              width: Get.width/1.4,
              decoration: borderGradientDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: containerBackgroundGradient(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.ic_google,
                        scale: 2.5,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Login With Google",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        GestureDetector(
          onTap: ()async {

            //facebookAuthentication(context);
            _onPressedLogInButton().then((value) {
              if(loginScreenController.profile!.userId.isNotEmpty){

                Get.off(() => HomeScreen());
              }

            });
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              height: 60,
              width: Get.width/1.4,
              decoration: borderGradientDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: containerBackgroundGradient(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.ic_facebook,
                        scale: 2.5,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Login With Facebook",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),

        GestureDetector(
          onTap: (){
            Get.off(() => HomeScreen());
          },
          child: Container(
            child: Text(
              "Skip",
              style:
                  TextStyle(fontSize: 19, decoration: TextDecoration.underline),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _onPressedLogInButton() async {
    await loginScreenController.plugin.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ],
    );
    await loginScreenController.updateLoginInfo();
    await loginScreenController.plugin.logOut();
  }

}
