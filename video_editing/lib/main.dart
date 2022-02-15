import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_editing/screens/splash_screen/splash_screen.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,

      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   // brightness: Brightness.dark,
      //   textTheme: const TextTheme(
      //     bodyText1: TextStyle(),
      //     bodyText2: TextStyle(),
      //   ).apply(
      //     bodyColor: Colors.white,
      //     displayColor: Colors.white,
      //   ),
      // ),
    );
  }
}
