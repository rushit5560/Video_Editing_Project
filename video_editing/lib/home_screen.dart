import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'crop_video_screen/compress_video.dart';
import 'music_add_screen/add_music.dart';
import 'video_editor_screen/video_editor_screen.dart';
import 'video_screen/VideoScreen.dart';



class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<String> tempList = [];
  var file;
  String _counter = "video";
  File? compressFile;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Img To Video')),

      body: Center(
        child: Column(
          children: [


            ElevatedButton(
              onPressed:()=> _pickVideo(context),
              child: const Text("Pick Video From Gallery"),
            ),

            ElevatedButton(
              onPressed: () {
                _compressVideo().then((value) {

                  //context.to(CompressVideo(compressFile: compressFile!, file: file,));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  CompressVideo(compressFile: compressFile!, file: file,)),
                  );
                });
              },
              child: Text('Compress Video From Gallery'),
            ),

            ElevatedButton(
              onPressed: () {
                _compressVideo1().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  CompressVideo(compressFile: compressFile!, file: file,)),
                  );
                });
              },
              child: Text('Compress Video From Camera'),
            ),

            ElevatedButton(
              onPressed: () async {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddMusic()),
                  );*/
                await videoPick();
              },
              child: Text('Add music'),
            ),

            ElevatedButton(
              onPressed: () {
                selectImages(context);
              },
              child: const Text('Create Video Using Multiple Images'),
            ),


          ],
        ),
      ),
    );
  }

  void selectImages(BuildContext context) async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    try {
      if (selectedImages!.isEmpty) {} else if (selectedImages.length == 1) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please Select Minimum 2 images"),
        ));
      } else if (selectedImages.length >= 2) {
        tempList.clear();
        for (int i = 0; i < selectedImages.length; i++) {
          tempList.add(selectedImages[i].path);
        }
        if (tempList.isNotEmpty) {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoScreen(imageList: tempList)));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('goToImgListScreen : $e');
      }
    }
  }

  void _pickVideo(BuildContext context) async {
    final XFile? file = await imagePicker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => VideoEditor(file: File(file.path))
      ));
    }
  }

  Future _compressVideo() async {

    if (Platform.isMacOS) {
      final typeGroup = XTypeGroup(label: 'videos', extensions: ['mov', 'mp4']);
      file = await openFile(acceptedTypeGroups: [typeGroup]);
    } else {
      final picker = ImagePicker();
      PickedFile? pickedFile = await picker.getVideo(source: ImageSource.gallery);
      file = File(pickedFile!.path);
    }
    if (file == null) {
      return;
    }
    await VideoCompress.setLogLevel(0);
    Fluttertoast.showToast(
        msg: "Compressing Video Please wait",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    final MediaInfo? info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    print(info!.path);
    if (info != null) {
      setState(() {
        _counter = info.path!;
        compressFile = File(_counter);
      });

    }
    GallerySaver.saveVideo(compressFile!.path,
        albumName: "OTWPhotoEditingDemo");

  }

  Future _compressVideo1() async {

    if (Platform.isMacOS) {
      final typeGroup = XTypeGroup(label: 'videos', extensions: ['mov', 'mp4']);
      file = await openFile(acceptedTypeGroups: [typeGroup]);
    } else {
      final picker = ImagePicker();
      PickedFile? pickedFile = await picker.getVideo(source: ImageSource.camera);
      file = File(pickedFile!.path);
    }
    if (file == null) {
      return;
    }
    await VideoCompress.setLogLevel(0);
    Fluttertoast.showToast(
        msg: "Compressing Video Please wait",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    final MediaInfo? info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    print(info!.path);
    if (info != null) {
      setState(() {
        _counter = info.path!;
        compressFile = File(_counter);
      });

    }
    GallerySaver.saveVideo(compressFile!.path,
        albumName: "OTWPhotoEditingDemo");
  }

  videoPick() async {
    final XFile? file = await imagePicker.pickVideo(source: ImageSource.gallery);
    //var images = await ExportVideoFrame.exportImage(file!.path, 10, 0);
    if (file != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddMusic(file: file,)),
      );
      // context.to(VideoEditor(file: File(file.path)));
    }
  }

  /*Future _compressVideo1() async {

    if (Platform.isMacOS) {
      final typeGroup = XTypeGroup(label: 'videos', extensions: ['mov', 'mp4']);
      file = await openFile(acceptedTypeGroups: [typeGroup]);
    } else {
      final picker = ImagePicker();
      PickedFile? pickedFile = await picker.getVideo(source: ImageSource.camera);
      file = File(pickedFile!.path);
    }
    if (file == null) {
      return;
    }
    await VideoCompress.setLogLevel(0);
    Fluttertoast.showToast(
        msg: "Compressing Video Please wait",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    final MediaInfo? info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    print(info!.path);
    if (info != null) {
      setState(() {
        _counter = info.path!;
        compressFile = File(_counter);
      });

    }
    GallerySaver.saveVideo(compressFile!.path,
        albumName: "OTWPhotoEditingDemo");
  }*/

  /*Future _compressVideo() async {

    if (Platform.isMacOS) {
      final typeGroup = XTypeGroup(label: 'videos', extensions: ['mov', 'mp4']);
      file = await openFile(acceptedTypeGroups: [typeGroup]);
    } else {
      final picker = ImagePicker();
      PickedFile? pickedFile = await picker.getVideo(source: ImageSource.gallery);
      file = File(pickedFile!.path);
    }
    if (file == null) {
      return;
    }
    await VideoCompress.setLogLevel(0);
    Fluttertoast.showToast(
        msg: "Compressing Video Please wait",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    final MediaInfo? info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    print(info!.path);
    if (info != null) {
      setState(() {
        _counter = info.path!;
        compressFile = File(_counter);
      });

    }
    GallerySaver.saveVideo(compressFile!.path,
        albumName: "OTWPhotoEditingDemo");

  }*/


}


/*
class VideoEditor extends StatefulWidget {
  VideoEditor({Key? key, required this.file}) : super(key: key);
  final File file;
  @override
  _VideoEditorState createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> with TickerProviderStateMixin {
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

  // late AnimationController _animationIconController1;

  //AudioCache ? audioCache;

  //late AudioPlayer audioPlayer;

  Duration _duration = new Duration();
  Duration _position = new Duration();

  // bool issongplaying = false;
  //
  // void seekToSeconds(int second) {
  //   Duration newDuration = Duration(seconds: second);
  //   audioPlayer.seek(newDuration);
  // }

  */
/* void initPlayer() {
    _animationIconController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
      reverseDuration: Duration(milliseconds: 750),
    );
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);
    // audioPlayer.getDuration().then((d) {
    //   setState(() {
    //     _duration = Duration(milliseconds: d);
    //   });
    // });
    // audioPlayer.getCurrentPosition().then((p) {
    //   setState(() {
    //     _position = Duration(minutes: p);
    //   });
    // });
    // audioPlayer.durationHandler = (d) => setState(() {
    //       _duration = d;
    //     });
    // audioPlayer.positionHandler = (p) => setState(() {
    //       _position = p;
    //     });
  }*//*


  @override
  void initState() {
    _controller = VideoEditorController.file(widget.file,
        maxDuration: Duration(seconds: 30))
      ..initialize().then((_) => setState(() {}));
    //_controller.video.setVolume(0);
    // iconController = AnimationController(
    //     vsync: this, duration: Duration(milliseconds: 1000));

    //audioPlayer1.open(Audio('assets/Song1.mp3'),autoStart: false,showNotification: true);
    //initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();

    // iconController.dispose();
    // audioPlayer1.dispose();
    super.dispose();
  }

  // late AnimationController
  // iconController;
  // AssetsAudioPlayer audioPlayer1 = AssetsAudioPlayer();
  bool isAnimated = false;

  void _openCropScreen() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context)=> CropScreen(controller: _controller)));
  }

  void _exportVideo() async {
    _isExporting.value = true;
    bool _firstStat = true;
    //NOTE: To use [-crf 17] and [VideoExportPreset] you need ["min-gpl-lts"] package
    await _controller.exportVideo(
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
            await showModalBottomSheet(
              context: context,
              backgroundColor: Colors.black54,
              builder: (_) => AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              ),
            );
            await _videoController.pause();
            _videoController.dispose();
          });
          GallerySaver.saveVideo(file.path,
              albumName: "OTWPhotoEditingDemo");
          _exportText = "Video success export!";
        } else {
          _exportText = "Error on export video :(";
        }

        setState(() => _exported = true);
        Misc.delayed(2000, () => setState(() => _exported = false));
      },
    );
  }

  void _exportCover() async {
    setState(() => _exported = false);
    await _controller.extractCover(
      onCompleted: (cover) {
        if (!mounted) return;

        if (cover != null) {
          _exportText = "Cover exported! ${cover.path}";
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.black54,
            builder: (BuildContext context) =>
                Image.memory(cover.readAsBytesSync()),
          );
          GallerySaver.saveImage(cover.path,
              albumName: "OTWPhotoEditingDemo");
        } else
          _exportText = "Error on cover exportation :(";

        setState(() => _exported = true);
        Misc.delayed(2000, () => setState(() => _exported = false));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? SafeArea(
          child: Stack(children: [
            Column(children: [
              _topNavBar(),
              Expanded(
                  child: DefaultTabController(
                      length: 2,
                      child: Column(children: [
                        Expanded(
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Stack(alignment: Alignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          CropGridViewer(
                                            controller: _controller,
                                            showGrid: false,
                                          ),

                                          Positioned(
                                              bottom: 5,
                                              child: file != null ? Image.file(file!,
                                                height: 50,
                                                width: MediaQuery.of(context).size.width,) : Container())
                                          // Positioned(
                                          //     bottom: 5,
                                          //       child: Text("WaterMark"))
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

                                              // setState(() {
                                              //   isplaying ? _animationIconController1!.reverse() : _animationIconController1!.forward();
                                              //   isplaying = !isplaying;
                                              //   print('isplaying : $isplaying');
                                              // });
                                              // if (issongplaying == false) {
                                              //   // audioCache!.play("Song1.mp3");
                                              //   audioPlayer.play('song1.mp3');
                                              //   setState(() {
                                              //     issongplaying = true;
                                              //     print('issongplaying1 : $issongplaying');
                                              //   });
                                              // } else {
                                              //   await Future.delayed(Duration(seconds: 1));
                                              //   await audioPlayer.pause();
                                              //   setState(() {
                                              //     issongplaying = false;
                                              //     print('issongplaying2 : $issongplaying');
                                              //   });
                                              // }

                                              */
/*setState(() {
                                            isAnimated = !isAnimated;

                                            if(isAnimated)
                                            {
                                              print('print: $isAnimated');
                                              _controller.video.play();
                                              iconController.forward();
                                              audioPlayer1.play();
                                            }else{
                                              print('print1: $isAnimated');
                                             // _controller.video.pause();
                                              iconController.reverse();
                                              audioPlayer1.pause();
                                            }


                                          });*//*

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
                            )),
                        Container(
                            height: 200,
                            margin: Margin.top(10),
                            child: Column(children: [
                              TabBar(
                                indicatorColor: Colors.white,
                                tabs: [
                                  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: Margin.all(5),
                                            child: Icon(Icons.content_cut)),
                                        Text('Trim')
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: Margin.all(5),
                                            child: Icon(Icons.video_label)),
                                        Text('Cover')
                                      ]),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
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
                        _customSnackBar(),
                        ValueListenableBuilder(
                          valueListenable: _isExporting,
                          builder: (_, bool export, __) => OpacityTransition(
                            visible: export,
                            child: AlertDialog(
                              backgroundColor: Colors.white,
                              title: ValueListenableBuilder(
                                valueListenable: _exportingProgress,
                                builder: (_, double value, __) =>
                                    TextDesigned(
                                      "Downloading video ${(value * 100).ceil()}%",
                                      color: Colors.black,
                                      bold: true,
                                    ),
                              ),
                            ),
                          ),
                        )
                      ])))
            ])
          ]))
          : Center(child: CircularProgressIndicator()),
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
                child: Icon(Icons.collections),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _controller.rotate90Degrees(RotateDirection.left),
                child: Icon(Icons.rotate_left),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _controller.rotate90Degrees(RotateDirection.right),
                child: Icon(Icons.rotate_right),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: _openCropScreen,
                child: Icon(Icons.crop),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: _exportCover,
                child: Icon(Icons.save_alt, color: Colors.white),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: _exportVideo,
                child: Icon(Icons.save),
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
            horizontalMargin: height / 4),
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
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: TextDesigned(
              _exportText,
              bold: true,
            ),
          ),
        ),
      ),
    );
  }
}
*/