import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_editing/common/common_widgets.dart';
import 'package:video_editing/screens/video_editor_screen/crop_screen_new.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';



class VideoEditorScreenNew extends StatefulWidget {
  final File file;
  const VideoEditorScreenNew({Key? key, required this.file}) : super(key: key);

  @override
  _VideoEditorScreenNewState createState() => _VideoEditorScreenNewState();
}

class _VideoEditorScreenNewState extends State<VideoEditorScreenNew> with SingleTickerProviderStateMixin {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  bool _exported = false;
  String _exportText = "";
  late VideoEditorController _controller;
  final ImagePicker imagePicker = ImagePicker();
  File? file;
  File? compressFile;
  bool isplaying = false;

  Duration _duration = new Duration();
  Duration _position = new Duration();
  late TabController tabController;

  @override
  void initState() {
    _controller = VideoEditorController.file(widget.file,
        maxDuration: Duration(seconds: 30))
      ..initialize().then((_) => setState(() {}));
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    tabController.dispose();
    // iconController.dispose();
    // audioPlayer1.dispose();
    super.dispose();
  }

  bool isAnimated = false;

  void _openCropScreen() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context)=> CropScreenNew(controller: _controller)));
  }

  void _exportVideo() async {
    _isExporting.value = true;
    bool _firstStat = true;
    //NOTE: To use [-crf 17] and [VideoExportPreset] you need ["min-gpl-lts"] package
    /*final File? file = */await _controller.exportVideo(
      // preset: VideoExportPreset.medium,
      // customInstruction: "-crf 17",
      onProgress: (statics) {
        // First statistics is always wrong so if first one skip it
        if (_firstStat) {
          _firstStat = false;
        } else {
          _exportingProgress.value = statics.getTime() /
              _controller.video.value.duration.inMilliseconds;
        }

      },
      onCompleted: (file) {
        _isExporting.value = false;
        if (!mounted) return;
        if (file != null) {
          final VideoPlayerController _videoController =
          VideoPlayerController.file(file);
          _videoController.initialize().then((value) async {
            setState(() {});
            //_videoController.setVolume(0);
            _videoController.play();
            _videoController.setLooping(true);
            // await showModalBottomSheet(
            //   context: context,
            //   backgroundColor: Colors.black54,
            //   builder: (_) => AspectRatio(
            //     aspectRatio: _videoController.value.aspectRatio,
            //     child: VideoPlayer(_videoController),
            //   ),
            // );
            await _videoController.pause();
            _videoController.dispose();
          });
          GallerySaver.saveVideo(file.path,
              albumName: "Video Maker");
          _exportText = "Video successfully Downloaded!";
        } else {
          _exportText = "Error on Download video :(";
        }

        setState(() => _exported = true);
        Misc.delayed(2000, () => setState(() => _exported = false));
      },
    );
    // _isExporting.value = false;
    // if (file != null) {
    //   final VideoPlayerController _videoController =
    //   VideoPlayerController.file(file!);
    //   _videoController.initialize().then((value) async {
    //     setState(() {});
    //     //_videoController.setVolume(0);
    //     _videoController.play();
    //     _videoController.setLooping(true);
    //     await showModalBottomSheet(
    //       context: context,
    //       backgroundColor: Colors.black54,
    //       builder: (_) => AspectRatio(
    //         aspectRatio: _videoController.value.aspectRatio,
    //         child: VideoPlayer(_videoController),
    //       ),
    //     );
    //     await _videoController.pause();
    //     _videoController.dispose();
    //   });
    //   GallerySaver.saveVideo(file!.path,
    //       albumName: "OTWPhotoEditingDemo");
    //   _exportText = "Video success export!";
    // } else{
    //   _exportText = "Error on export video :(";
    // }
    // setState(() => _exported = true);
    // Misc.delayed(2000, () => setState(() => _exported = false));
  }

  void _exportCover() async {
    setState(() => _exported = false);
    /*final File? cover = */await _controller.extractCover(
      onCompleted: (cover) {
        if (!mounted) return;

        if (cover != null) {
          _exportText = "Video Cover Downloaded! ${cover.path}";
          // showModalBottomSheet(
          //   context: context,
          //   backgroundColor: Colors.black54,
          //   builder: (BuildContext context) =>
          //       Image.memory(cover.readAsBytesSync(),fit: BoxFit.cover,),
          // );
          GallerySaver.saveImage(cover.path,
              albumName: "Video Maker");
        } else{
          _exportText = "Error on cover Downloaded :(";
        }


        setState(() => _exported = true);
        Misc.delayed(2000, () => setState(() => _exported = false));
      },
      // );
    );

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showAlertDialog(),
      child: Scaffold(
        body: Stack(
          children: [
            MainBackgroundWidget(),

            SafeArea(
              child: _controller.initialized
                  ? SafeArea(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                      children: [
                    Column(children: [
                      _topNavBar(),
                      SizedBox(height: 10,),
                      Expanded(
                          child: DefaultTabController(
                              length: 2,
                              child: Column(children: [
                                Expanded(
                                    child: Container(
                                     //margin: EdgeInsets.only(left: 10, right: 10),
                                      child: TabBarView(
                                        controller: tabController,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          Stack(alignment: Alignment.center,
                                              children: [
                                                Stack(
                                                  alignment: Alignment.bottomRight,
                                                  children: [
                                                    Container(
                                                      //width: Get.width,
                                                      //color: Colors.transparent,
                                                      // decoration: BoxDecoration(
                                                      //   color: Colors.transparent,
                                                      // ),
                                                      child: AspectRatio(

                                                        aspectRatio: (Get.width*2)/(Get.height),
                                                        child: CropGridViewer(
                                                          controller: _controller,
                                                          showGrid: false,
                                                          //horizontalMargin: 10,
                                                        ),
                                                      ),
                                                    ),

                                                    Positioned(
                                                        bottom: 5,
                                                        child: file != null ? Image.file(file!,
                                                          height: 50,
                                                          width: MediaQuery.of(context).size.width,) : Container())
                                                  ],
                                                ),

                                                AnimatedBuilder(
                                                  animation: _controller.video,
                                                  builder: (_, __) => OpacityTransition(
                                                    visible: !_controller.isPlaying,
                                                    child: GestureDetector(
                                                      //onTap: _controller.video.play,
                                                      //onTap: ()=> _controller.video.play,
                                                      onTap: () async {

                                                        _controller.video.play();

                                                      },
                                                      child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(Icons.play_arrow,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]
                                          ),
                                          //Container()
                                          CoverViewer(controller: _controller)
                                        ],
                                      ),
                                    )),
                                SizedBox(height: 10,),
                                Container(
                                    height: 200,
                                    //margin: Margin.all(10),
                                    child: Column(children: [
                                      TabBar(
                                        //isScrollable: true,
                                        indicatorColor: Colors.transparent,
                                        //indicatorSize: TabBarIndicatorSize.label,
                                        labelColor: Colors.black,
                                        // labelPadding:
                                        // EdgeInsets.only(top: 10.0, bottom: 5, left: 10, right: 10),
                                        unselectedLabelColor: Colors.black38,
                                        controller:  tabController,
                                        labelStyle: TextStyle(fontSize: 17, color: Colors.grey),
                                        tabs: [
                                          Container(
                                            width: Get.width/2.2,
                                            height: 50,
                                            decoration: borderGradientDecoration(),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Container(
                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                decoration: containerBackgroundGradient(),
                                                child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                          padding: Margin.all(5),
                                                          child: Icon(Icons.content_cut, color: Colors.black,)),
                                                      Text(
                                                          'Trim',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: Get.width/2.2,
                                            height: 50,
                                            decoration: borderGradientDecoration(),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Container(
                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                decoration: containerBackgroundGradient(),
                                                child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                          padding: Margin.all(5),
                                                          child: Icon(Icons.video_label, color: Colors.black,)),
                                                      Text(
                                                          'Cover',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          controller: tabController,
                                          children: [
                                            Container(
                                                child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: _trimSlider())),
                                            Container(
                                              child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [_coverSelection()]),
                                            ),
                                          ],
                                        ),
                                      )
                                    ])),

                              ])))
                    ]),


                    ValueListenableBuilder(
                      valueListenable: _isExporting,
                      builder: (_, bool export, __) => OpacityTransition(
                        visible: export,
                        child:  ValueListenableBuilder(
                            valueListenable: _exportingProgress,
                            builder: (_, double value, __) {
                              print('vslue: $value');
                              return Container(
                                height: 55,
                                width: Get.width/2,
                                color: Colors.black,
                                child: Center(
                                  child: Text(
                                      "Downloading video ${(value * 100).ceil()}%",
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)

                                  ),
                                ),
                              );
                            }

                          ),
                      ),
                    ),
                        _customSnackBar(),

                  ]))
                  : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }


  Widget _topNavBar() {
    return SafeArea(
      child: Container(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: gallery,
                child: Icon(Icons.collections, color: Colors.black),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _controller.rotate90Degrees(RotateDirection.left),
                child: Icon(Icons.rotate_left, color: Colors.black),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _controller.rotate90Degrees(RotateDirection.right),
                child: Icon(Icons.rotate_right, color: Colors.black),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: _openCropScreen,
                child: Icon(Icons.crop, color: Colors.black),
              ),
            ),

            // Expanded(
            //   child: GestureDetector(
            //     onTap: _exportCover,
            //     child: Icon(Icons.save_alt, color: Colors.black),
            //   ),
            // )
            Expanded(
              child: GestureDetector(
                onTap: (){
                  //_exportVideo
                  if(tabController.index == 0){
                    _exportVideo();
                  }else{
                    _exportCover();
                  }
                },
                child: Icon(Icons.save, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void gallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        file = File(image.path);
      });
    }
    // file = image != null ? File(image.path) : null;
    // setState(() {
    //   compressFile = image != null ? File(image.path) : null;
    // });
    // if(file != null){
    //   Get.to(()=> GalleryScreen(file: file!,compressFile: compressFile,));
    // }

  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0')
  ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: _controller.video,
        builder: (_, __) {
          final duration = _controller.video.value.duration.inSeconds;
          final pos = _controller.trimPosition * duration;
          final start = _controller.minTrim * duration;
          final end = _controller.maxTrim * duration;

          return Padding(
            padding: Margin.horizontal(height / 4),
            child: Row(children: [
              TextDesigned(formatter(Duration(seconds: pos.toInt()))),
              Expanded(child: SizedBox()),
              OpacityTransition(
                visible: _controller.isTrimming,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  TextDesigned(formatter(Duration(seconds: start.toInt()))),
                  SizedBox(width: 10),
                  TextDesigned(formatter(Duration(seconds: end.toInt()))),
                ]),
              )
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: Margin.vertical(height / 4),
        child: TrimSlider(
            child: TrimTimeline(
                controller: _controller, margin: EdgeInsets.only(top: 10)),
            controller: _controller,
            height: height,
            horizontalMargin: height / 4
        ),
      ),
      // Slider(
      //   activeColor: Colors.blue,
      //   inactiveColor: Colors.grey,
      //   value: _position.inSeconds.toDouble(),
      //   max: _duration.inSeconds.toDouble(),
      //   onChanged: (double value) {
      //     setState(() {
      //       seekToSeconds(value.toInt());
      //       value = value;
      //     });
      //   },
      // ),
    ];
  }

  Widget _coverSelection() {
    return Container(
        margin: Margin.horizontal(height / 4),
        child: CoverSelection(
          controller: _controller,
          height: height,
          nbSelection: 8,
        ));
  }

  Widget _customSnackBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SwipeTransition(
        visible: _exported,
        //direction: SwipeDirection.fromBottom,
        child: Container(
          height: height,
          width: double.infinity,
          color: Colors.black,
          child: Center(
            child: Text(
              _exportText,style: TextStyle(color: Colors.white),
            ),
          ),
        ),
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
