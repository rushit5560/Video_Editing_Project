import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
//import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_media_gallery_saver/flutter_media_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editing/common/common_widgets.dart';
import 'package:video_editing/common/image_url.dart';
import 'package:video_player/video_player.dart';

class AddMusic extends StatefulWidget {
  XFile file;
  AddMusic({required this.file});

  @override
  _AddMusicState createState() => _AddMusicState();
}

class _AddMusicState extends State<AddMusic> with TickerProviderStateMixin {

  VideoPlayerController ? controller;

  // To Do
  late AnimationController animationIconController1;
  AudioCache ? audioCache;
  late AudioPlayer audioPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();

  bool issongplaying = false;

  bool isplaying = false;
  int ? time;
  Duration ? dur;
  final GlobalKey key = GlobalKey();
  File ? video;

  void seekToSeconds(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  // List<String> musicList = [
  //   'assets/Song1.mp3',
  //   'assets/Song2.mp3'
  // ];
  List<Music> musicList = [];
  String ? selectedMusic;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.file(File(widget.file.path))
      ..initialize().then((_) async {
        //_controller!.setLooping(true);
        controller!.setVolume(0);

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
    controller!.addListener(checkVideo);

    initPlayer();
    //load_path_video();
    musicData();
  }

  musicData(){
    musicList.add(
        Music(name: 'Song1.Mp3', musicUrl: 'Song1.mp3'),
    );
    musicList.add(
      Music(name: 'Song2.Mp3', musicUrl: 'Song2.mp3'),
    );
  }

  void checkVideo(){
    // Implement your calls inside these conditions' bodies :
    if(controller!.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }
    print('Video position: ${controller!.value.position}');
    print('Video duration: ${controller!.value.duration}');
    if(controller!.value.position == controller!.value.duration) {
      print('video Ended');
      audioPlayer.stop();
    }

  }

  void initPlayer() {
    animationIconController1 = AnimationController(
      vsync: this,
      duration:  Duration(milliseconds: 750),
      reverseDuration: Duration(milliseconds: 750),
    );

    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);

    //_controller!.value.isPlaying ? audioCache!.play("Song1.mp3") : audioPlayer.pause();

    // audioPlayer.onDurationChanged.listen((Duration d) {
    //   setState(() {
    //     _duration = d;
    //   });
    //   print('Max duration: $_duration');
    // });

    // audioPlayer.getDuration().then((d) {
    //
    //   setState(() {
    //     _duration = Duration(milliseconds: d);
    //     print('Total duration: ${_duration.inSeconds}');
    //   });
    // });
    // audioPlayer.getCurrentPosition().then((p) {
    //   setState(() {
    //     _position = Duration(minutes: p);
    //     print('position: $_position');
    //   });
    // });
    // audioPlayer.durationHandler = (d) => setState(() {
    //       _duration = d;
    //     });
    // audioPlayer.positionHandler = (p) => setState(() {
    //       _position = p;
    //     });
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }
  String ? dirPath;
  bool loading = false;



  Future _capturePng() async {
    try {
      DateTime time = DateTime.now();
      String imgName = "${time.hour}-${time.minute}-${time.second}";
      print('inside');
      RenderRepaintBoundary boundary =
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      print(boundary);
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      print("image:===$image");
      final directory = (await getApplicationDocumentsDirectory()).path;
      print("Directory: $directory");
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      print("byte data:===$byteData");
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/$imgName.mp4');
      print("Image path: ${imgFile.writeAsBytes(pngBytes)}");
      await imgFile.writeAsBytes(pngBytes);
      setState(() {
        video = imgFile;
      });
      print("File====:${video!}");
      print("File path====:${video!.path}");
      loadPathVideo();
      // await saveImage();
    } catch (e) {
      print(e);
    }
  }

  Future loadPathVideo() async {

    // loading = true;
    //
    // final Directory extDir = await getApplicationDocumentsDirectory();
    //
    // setState(() {
    //   dirPath = '${extDir.path}/Movies/2019-11-08.mp4';
    //   print("Directory path: $dirPath");
    //   loading = false;
    //   // if I print ($dirPath) I have /data/user/0/com.XXXXX.flutter_video_test/app_flutter/Movies/2019-11-08.mp4
    // });
    // return "";


    // DateTime time= DateTime.now();
    // final String video = "video_maker_${time.hour}_${time.minute}_${time.second}." + "mp4";
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // print('Document directory: ${documentsDirectory.path}');
    // File videoFile = File("${documentsDirectory.path}/$video");
    //final video = controller!.value.duration;

    // var appDocDir = await getTemporaryDirectory();
    // String savePath = appDocDir.path + "/temp.mp4";
    // if(File(savePath).existsSync()){
    //   final result = await FlutterGallerySaver.saveVideo(savePath);
    //   print(result);
    //   _toastInfo("$result");
    // }else{
    //   String fileUrl = widget.file.path;
    //   await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
    //     print((count / total * 100).toStringAsFixed(0) + "%");
    //   });
    //   final result = await FlutterGallerySaver.saveVideo(savePath);
    //   print(result);
    //   _toastInfo("$result");
    // }
    await GallerySaver.saveVideo('${video!.path}', albumName: "Video Maker");
    Fluttertoast.showToast(msg: "Save in to gallery");

  }
  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  _saveVideo() async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/temp.mp4";
    print('savePath: $savePath');
    if(File(savePath).existsSync()){
      final result = await ImageGallerySaver.saveFile(savePath);
      print('result: $result');
    }
    await Dio().download('${widget.file.path}', savePath);

  }

  String ? nowTime;
  bool mute = false;
  int selectedIndex = 0;

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
                  children: [
                    appBar(),
                    SizedBox(height: 15,),
                    Expanded(
                      child: RepaintBoundary(
                        key: key,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: AspectRatio(
                                  aspectRatio: controller!.value.aspectRatio,
                                  child: VideoPlayer(controller!)),
                            ),


                            GestureDetector(
                              onTap: () async {
                                //print('Video Duration: ${_controller!.value.duration.inSeconds}');
                                print('Duration1: $_duration');

                                setState(() {
                                  controller!.value.isPlaying
                                      ? controller!.pause()
                                      : controller!.play();
                                  print('data source : ${controller!.dataSource}');
                                });
                                //
                                // //to do
                                // setState(() {
                                //   isplaying
                                //       ? animationIconController1.reverse()
                                //       : animationIconController1.forward();
                                //   isplaying = !isplaying;
                                // });
                                if (controller!.value.isPlaying) {
                                  print('isPlaying: ${controller!.value.isPlaying}');
                                  audioCache!.play("$selectedMusic");
                                  //audioCache!.play("Song2.mp3");
                                  // audioPlayer.play('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
                                  //  setState(() {
                                  //    issongplaying = true;
                                  //  });
                                } else {
                                  print('isPlaying: ${controller!.value.isPlaying}');
                                  audioPlayer.pause();

                                  // setState(() {
                                  //   issongplaying = false;
                                  // });
                                }
                              },
                              child: Icon(
                                controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),

                            Positioned(
                              bottom: 0,left: 0,right: 0,
                              child: VideoProgressIndicator(
                                controller!,
                                allowScrubbing: true,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),

                    Text("Music List", style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                    SizedBox(height: 5,),
                    ListView.builder(
                        itemCount: musicList.length,
                        shrinkWrap: true,
                        //scrollDirection: Axis.vertical,
                        itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: (){
                              selectedMusic = musicList[index].musicUrl;
                              setState(() {
                                selectedIndex = index;
                              });
                              print(selectedMusic);
                              print(index);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(musicList[index].name,
                                      style: TextStyle(color: selectedIndex == index  ? Colors.black87: Colors.grey.shade600),),
                                  ),
                                  Container(
                                    child: selectedIndex == index ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                                  )
                                ],
                              ),
                            ),
                          );
                        })



                  ],
                ),
              ),
            )
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
                    "Add Music",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //Container()
                // GestureDetector(
                //   onTap: (){
                //     if(controller!.value.isPlaying){
                //       if(mute){
                //
                //       } else{
                //         controller!.setVolume(0);
                //       }
                //     }
                //   },
                //   child: Container(
                //     child: Icon(Icons.volume_mute),
                //   ),
                // )
                GestureDetector(
                  onTap: () async {
                    //Fluttertoast.showToast(msg: 'Please Wait...', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 1,);
                    // await _capturePng().then((value) {
                    //   Get.back();
                    // });
                    //load_path_video();
                    _capturePng();
                    //loadPathVideo();
                    //_saveVideo();
                  },
                  child: Container(child: Icon(Icons.check_rounded)),
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

class BasicOverlayWidget extends StatelessWidget {
  //const BasicOverlayWidget({Key? key}) : super(key: key);
  VideoPlayerController controller;
  BasicOverlayWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,left: 0,right: 0,
      child: VideoProgressIndicator(
          controller,
          allowScrubbing: true,
      ),
    );
  }
}

class Music {
  String musicUrl;
  String name;

  Music({required this.musicUrl, required this.name});
}