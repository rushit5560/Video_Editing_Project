import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_editing/common/common_widgets.dart';
import 'package:video_editing/common/image_url.dart';
import 'package:video_editing/controller/home_screen_controller/home_screen_controller.dart';
import 'package:video_editing/screens/compress_video_screen/compress_video.dart';
import 'package:video_editing/screens/music_add_screen/add_music.dart';
import 'package:video_editing/screens/profile_screen/profile_screen.dart';
import 'package:video_editing/screens/video_editor_screen/video_editor_screen_new.dart';



class HeaderTextModule extends StatelessWidget {
  const HeaderTextModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Image.asset(
            Images.ic_launcher,
            height: Get.width * 0.30,
            width: Get.width * 0.30,
          ),
        ),
        SizedBox(height: 15),
        Container(
          child: Text(
            "Video Editor",
            style: TextStyle(fontSize: 50, fontFamily: "Lemon Jelly"),
          ),
        ),
      ],
    );
  }
}

class VideoEditModule extends StatelessWidget {
  VideoEditModule({Key? key}) : super(key: key);
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     // onTap: () => _pickVideo(context),
      onTap: () {
        modalBottomSheetVideoEdit(context);
        //Get.back();
      },
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            width: Get.width,
            height: 50,
            alignment: Alignment.centerLeft,
            decoration: containerBackgroundGradient(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image(
                      image: AssetImage(Images.ic_video_editor),
                      height: 40,
                      width: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Video Edit',
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickVideoFromGallery(BuildContext context) async {
    final XFile? file = await imagePicker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      Get.back();
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => VideoEditorScreenNew(file: File(file.path))
      ));
    }
  }

  void pickVideoFromCamera(BuildContext context) async {
    final XFile? file = await imagePicker.pickVideo(source: ImageSource.camera);
    if (file != null) {
      Get.back();
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => VideoEditorScreenNew(file: File(file.path))
      ));
    }
  }

  modalBottomSheetVideoEdit(BuildContext context){
    return showModalBottomSheet(
      context: context,
      builder: (context) {
    return Wrap(
      children: [
        ListTile(
          onTap: (){
            pickVideoFromGallery(context);
          },
          leading: Icon(Icons.collections),
          title: Text('Gallery'),
        ),
        ListTile(
          onTap: (){
            pickVideoFromCamera(context);
          },
          leading: Icon(Icons.camera),
          title: Text('Camera'),
        ),
      ],
    );
    },
    );
  }


}

class CompressVideoModule extends StatefulWidget {

  @override
  State<CompressVideoModule> createState() => _CompressVideoModuleState();
}

class _CompressVideoModuleState extends State<CompressVideoModule> {
  var file;

  File? compressFile;

  final controller = Get.find<HomeScreenController>();
  Subscription ? subscription;
  double ? progress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = VideoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        this.progress = progress;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    VideoCompress.cancelCompression();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = progress == null ? progress : progress! / 100;
    return GestureDetector(
      onTap: () {
        modalBottomSheetVideoEdit(context, value);
      },
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            width: Get.width,
            height: 50,
            alignment: Alignment.centerLeft,
            decoration: containerBackgroundGradient(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image(
                      image: AssetImage(Images.ic_compress_video),
                      height: 40,
                      width: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Compress Video',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  modalBottomSheetVideoEdit(BuildContext context, value){
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              onTap: () {
                //pickVideoFromGallery(context);

              compressVideoFromGallery(value).then((value) {
                Get.back();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  CompressVideo(compressFile: compressFile!, file: file,)),
                );
              });
                //Get.back();
              },
              leading: Icon(Icons.collections),
              title: Text('Gallery'),
            ),
            ListTile(
              onTap: (){
                compressVideoFromCamera().then((value) {
                  //context.to(CompressVideo(compressFile: compressFile!, file: file,));
                  Get.back();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  CompressVideo(compressFile: compressFile!, file: file,)),
                  );
                });
                //Get.back();
              },
              leading: Icon(Icons.camera),
              title: Text('Camera'),
            ),
          ],
        );
      },
    );
  }

  Future compressVideoFromGallery(value) async {

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
    showDialog(
        context: context,
        //barrierDismissiible: false,
        builder: (context) {
          return Dialog(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Compressing Video ...', style: TextStyle(fontSize: 20),),
                    SizedBox(height: 20,),
                    LinearProgressIndicator(value: value, minHeight: 12,),
                    SizedBox(height: 15,),
                    ElevatedButton(
                      onPressed: (){
                        VideoCompress.cancelCompression();
                        Get.back();
                      },
                      child: Text("Cancel"),
                    )
                  ],
                ),
              )
          );
        }
    );
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
    //CircularProgressIndicator();
    final MediaInfo? info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    print(info!.path);
    if (info != null) {
      // setState(() {
      controller.counter.value = info.path!;
        compressFile = File(controller.counter.value);
      // });

    } /*else{
      CircularProgressIndicator();
    }*/


  }

  Future compressVideoFromCamera() async {

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
      // setState(() {
      controller.counter.value = info.path!;
      compressFile = File(controller.counter.value);
      // });

    }
    // GallerySaver.saveVideo(compressFile!.path,
    //     albumName: "OTWPhotoEditingDemo");

  }
}


class AddMusicModule extends StatelessWidget {
  AddMusicModule({Key? key}) : super(key: key);
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        modalBottomSheetVideoEdit(context);
        },
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            width: Get.width,
            height: 50,
            alignment: Alignment.centerLeft,
            decoration: containerBackgroundGradient(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image(
                      image: AssetImage(Images.ic_add_music),
                      height: 40,
                      width: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Add Music',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  modalBottomSheetVideoEdit(BuildContext context){
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              onTap: (){
                videoPickFromGallery(context);
              },
              leading: Icon(Icons.collections),
              title: Text('Gallery'),
            ),
            ListTile(
              onTap: (){
                videoPickFromCamera(context);
                //Get.back();
              },
              leading: Icon(Icons.camera),
              title: Text('Camera'),
            ),
          ],
        );
      },
    );
  }

  videoPickFromGallery(BuildContext context) async {
      final XFile? file = await imagePicker.pickVideo(source: ImageSource.gallery);
      //var images = await ExportVideoFrame.exportImage(file!.path, 10, 0);
      if (file != null) {
        Get.back();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddMusic(file: file)),
        );
        // context.to(VideoEditor(file: File(file.path)));
      }
    }

  videoPickFromCamera(BuildContext context) async {
    final XFile? file = await imagePicker.pickVideo(source: ImageSource.camera);
    //var images = await ExportVideoFrame.exportImage(file!.path, 10, 0);
    if (file != null) {
      Get.back();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddMusic(file: file)),
      );
      // context.to(VideoEditor(file: File(file.path)));
    }
  }
}

class AddProfile extends StatelessWidget {
  // const AddProfile({Key? key}) : super(key: key);
  // UserCredential ? result;
  // AddProfile({this.result});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(() => ProfileScreen());
      },
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            width: Get.width,
            height: 50,
            alignment: Alignment.centerLeft,
            decoration: containerBackgroundGradient(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image(
                      image: AssetImage(Images.ic_profile),
                      height: 40,
                      width: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

