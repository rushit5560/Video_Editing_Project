import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:video_editing/common/common_widgets.dart';
import 'package:video_editing/common/image_url.dart';
import 'package:video_player/video_player.dart';


class CompressVideo extends StatefulWidget {
  //const CompressVideo({Key? key}) : super(key: key);
  File compressFile;
  File file;
  CompressVideo({Key? key, required this.compressFile, required this.file}) : super(key: key);

  @override
  _CompressVideoState createState() => _CompressVideoState();
}

class _CompressVideoState extends State<CompressVideo> {
  int decimal = 2;
  VideoPlayerController ? controller;
  VideoPlayerController ? controller1;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.file(File(widget.compressFile.path))
      ..initialize().then((_) async {
        //_controller!.setLooping(true);
        //controller!.setVolume(0);

        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(()  {
          print('Video Duration: ${controller!.value.duration.inSeconds}');

          // if(_controller!.value.position == _controller!.value.duration){
          //     setState(() {
          //       Duration player = Duration(milliseconds: _controller!.value.position.inMilliseconds.round());
          //       nowTime = [player.inHours, player.inMinutes, player.inSeconds]
          //           .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
          //           .join(':');
          //
          //     });
          //     print('now time: $nowTime');
          //     if(nowTime!.isEmpty){
          //        audioPlayer.pause();
          //        audioPlayer.stop();
          //     }
          //   }else{
          //     print('empty');
          //     audioPlayer.pause();
          //     audioPlayer.stop();
          //   }


          //if(_controller!.value.duration)
          //_duration = _controller!.value.duration;
        });
      });

    controller1 = VideoPlayerController.file(File(widget.file.path))
      ..initialize().then((_) async {
        //_controller!.setLooping(true);
        //controller!.setVolume(0);

        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(()  {
          print('Video Duration: ${controller1!.value.duration.inSeconds}');

          // if(_controller!.value.position == _controller!.value.duration){
          //     setState(() {
          //       Duration player = Duration(milliseconds: _controller!.value.position.inMilliseconds.round());
          //       nowTime = [player.inHours, player.inMinutes, player.inSeconds]
          //           .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
          //           .join(':');
          //
          //     });
          //     print('now time: $nowTime');
          //     if(nowTime!.isEmpty){
          //        audioPlayer.pause();
          //        audioPlayer.stop();
          //     }
          //   }else{
          //     print('empty');
          //     audioPlayer.pause();
          //     audioPlayer.stop();
          //   }


          //if(_controller!.value.duration)
          //_duration = _controller!.value.duration;
        });
      });
    //controller!.addListener(checkVideo);

  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
    controller1!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Original File Size In MB: ${widget.file.lengthSync()/(1024 * 1024)} MB');
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
                  children: [

                    appBar(),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [


                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Original",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
                                  SizedBox(height: 5),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      controller1!.value.isInitialized
                                          ? Container(
                                        height: Get.height /2,
                                        child: VideoPlayer(controller1!),
                                      )
                                          :   Container(),

                                      GestureDetector(
                                        onTap: () async {
                                          //print('Video Duration: ${_controller!.value.duration.inSeconds}');

                                          setState(() {
                                            controller1!.value.isPlaying
                                                ? controller1!.pause()
                                                : controller1!.play();
                                            print('data source : ${controller1!.dataSource}');
                                          });
                                        },
                                        child: Icon(
                                          controller1!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Compress",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
                                  SizedBox(height: 5),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      controller!.value.isInitialized
                                          ? Container(
                                        height: Get.height /2,
                                        child: VideoPlayer(controller!),
                                      )
                                          :   Container(),

                                      GestureDetector(
                                        onTap: () async {
                                          //print('Video Duration: ${_controller!.value.duration.inSeconds}');

                                          setState(() {
                                            controller!.value.isPlaying
                                                ? controller!.pause()
                                                : controller!.play();
                                            print('data source : ${controller!.dataSource}');
                                          });
                                        },
                                        child: Icon(
                                          controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        widget.file.toString().isNotEmpty ? Text('Original video size: ${widget.file.lengthSync()} KB(${widget.file.lengthSync()/(1024 * 1024)} MB)') : const Text('0'),
                        SizedBox(height: 5,),
                        widget.compressFile.toString().isNotEmpty ? Text('Compress video size: ${widget.compressFile.lengthSync()} KB(${widget.compressFile.lengthSync()/(1024 * 1024)} MB)') : const Text('0'),

                        // Text('Original path: ${widget.file.path}'),
                        // SizedBox(height: 10,),
                        // Text('Compress path: ${widget.compressFile.path}'),
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
                GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: "Save in to gallery");
                    Get.back();
                    GallerySaver.saveVideo(widget.compressFile.path,
                        albumName: "Video Maker");
                  },
                  child: Container(
                    child: Icon(Icons.download),
                  ),
                ),
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
