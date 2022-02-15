import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_editing/common/common_widgets.dart';
import 'package:video_editing/crop_video_screen/compress_video.dart';
import 'package:video_editing/music_add_screen/add_music.dart';
import 'package:video_editing/video_editor_screen/video_editor_screen.dart';



class HeaderTextModule extends StatelessWidget {
  const HeaderTextModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // child: Image.asset(Images.ic_logo, scale: 5,),
        ),
        SizedBox(height: 15),
        Container(
          child: Text(
            "Scan4PDF",
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
              child: Text(
                'Video Edit',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
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
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => VideoEditor(file: File(file.path))
      ));
    }
  }

  void pickVideoFromCamera(BuildContext context) async {
    final XFile? file = await imagePicker.pickVideo(source: ImageSource.camera);
    if (file != null) {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => VideoEditor(file: File(file.path))
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
            //Get.back();
          },
          leading: Icon(Icons.collections),
          title: Text('Gallery'),
        ),
        ListTile(
          onTap: (){
            pickVideoFromCamera(context);
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


}

class CompressVideoFromGalleryModule extends StatefulWidget {
  CompressVideoFromGalleryModule({Key? key}) : super(key: key);
  @override
  State<CompressVideoFromGalleryModule> createState() => _CompressVideoFromGalleryModuleState();
}
class _CompressVideoFromGalleryModuleState extends State<CompressVideoFromGalleryModule> {
  var file;
  String _counter = "video";
  File? compressFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _compressVideo().then((value) {

          //context.to(CompressVideo(compressFile: compressFile!, file: file,));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  CompressVideo(compressFile: compressFile!, file: file,)),
          );
        });
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
              child: Text(
                'Compress Video From Gallery',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
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
}

class CompressVideoFromCameraModule extends StatefulWidget {
  CompressVideoFromCameraModule({Key? key}) : super(key: key);
  @override
  State<CompressVideoFromCameraModule> createState() => _CompressVideoFromCameraModuleState();
}
class _CompressVideoFromCameraModuleState extends State<CompressVideoFromCameraModule> {
  var file;
  String _counter = "video";
  File? compressFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _compressVideo1().then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  CompressVideo(compressFile: compressFile!, file: file,)),
          );
        });
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
              child: Text(
                'Compress Video From Camera',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
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
}

class AddMusicModule extends StatelessWidget {
  AddMusicModule({Key? key}) : super(key: key);
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        videoPick() async {
          final XFile? file = await imagePicker.pickVideo(source: ImageSource.gallery);
          //var images = await ExportVideoFrame.exportImage(file!.path, 10, 0);
          if (file != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMusic(file: file)),
            );
            // context.to(VideoEditor(file: File(file.path)));
          }
        }
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
              child: Text(
                'Add Music',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

