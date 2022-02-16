import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_editing/common/common_widgets.dart';
import 'package:video_editing/common/image_url.dart';


class CompressVideo extends StatefulWidget {
  //const CompressVideo({Key? key}) : super(key: key);
  File compressFile;
  File file;
  CompressVideo({Key? key, required this.compressFile, required this.file}) : super(key: key);

  @override
  _CompressVideoState createState() => _CompressVideoState();
}

class _CompressVideoState extends State<CompressVideo> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showAlertDialog(),
      child: Scaffold(
        body: Stack(
          children: [
            MainBackgroundWidget(),

            SafeArea(
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    appBar(),

                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.file.toString().isNotEmpty ? Text('Original video size: ${widget.file.lengthSync()} KB') : const Text('0'),
                        widget.compressFile.toString().isNotEmpty ? Text('Compress video size: ${widget.compressFile.lengthSync()} KB') : const Text('0'),
                        SizedBox(height: 10,),
                        Text('Original path: ${widget.file.path}', textAlign: TextAlign.center,),
                        SizedBox(height: 10,),
                        Text('Compress path: ${widget.compressFile.path}', textAlign: TextAlign.center,),
                      ],
                    ),

                    Container()


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                    //Get.back();
                    showAlertDialog();
                  },
                  child: Container(
                      child: Image.asset(
                        Images.ic_left_arrow,
                        scale: 2.5,
                      )),
                ),
                Container(
                  child: Text(
                    "Compress Video",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container()
                /*GestureDetector(
                  onTap: () {
                    controller.updateCrop();
                    Get.back();
                    //context.goBack();
                  },
                  child: Container(
                    child: Icon(Icons.check_rounded),
                  ),
                ),*/
              ],
            )),
      ),
    );
  }

  showAlertDialog() {

    Widget cancelButton = TextButton(
      child: Text("No", style: TextStyle(fontFamily: ""),),
      onPressed:  () {
        Get.back();
        //Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes", style: TextStyle(fontFamily: ""),),
      onPressed:  () async{
        //await _capturePng().then((value) {
        Get.back();
        Get.back();
        //});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("AlertDialog"),
      content: Text("Do you want to exit?", style: TextStyle(fontFamily: ""),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
