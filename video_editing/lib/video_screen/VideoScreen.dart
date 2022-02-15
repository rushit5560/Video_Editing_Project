// /*
// import 'dart:io';
//
// import 'package:ff_pckg_demo/player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_ffmpeg/completed_ffmpeg_execution.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:flutter_ffmpeg/statistics.dart';
// import 'package:path_provider/path_provider.dart';
//
// class VideoScreen extends StatefulWidget {
//   List<String> imageList;
//   VideoScreen({Key? key, required this.imageList}) : super(key: key);
//
//   @override
//   State<VideoScreen> createState() => _VideoScreenState();
//
//   static String generateEncodeVideoScript(
//       String image1Path,
//       String image2Path,
//       String image3Path,
//       String videoFilePath,
//       String videoCodec,
//       String customOptions) {
//     print('image1Path : $image1Path');
//     print('image2Path : $image2Path');
//     print('image3Path : $image3Path');
//
//     return "-hide_banner -y -loop 1 -i '" +
//         image1Path +
//         "' " +
//         "-loop   1 -i \"" +
//         image2Path +
//         "\" " +
//         "-loop 1   -i \"" +
//         image3Path +
//         "\" " +
//         "-filter_complex " +
//         "\"[0:v]setpts=PTS-STARTPTS,scale=w='if(gte(iw/ih,640/427),min(iw,640),-1)':h='if(gte(iw/ih,640/427),-1,min(ih,427))',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1,split=2[stream1out1][stream1out2];" +
//         "[1:v]setpts=PTS-STARTPTS,scale=w='if(gte(iw/ih,640/427),min(iw,640),-1)':h='if(gte(iw/ih,640/427),-1,min(ih,427))',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1,split=2[stream2out1][stream2out2];" +
//         "[2:v]setpts=PTS-STARTPTS,scale=w='if(gte(iw/ih,640/427),min(iw,640),-1)':h='if(gte(iw/ih,640/427),-1,min(ih,427))',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1,split=2[stream3out1][stream3out2];" +
//         "[stream1out1]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=3,select=lte(n\\,90)[stream1overlaid];" +
//         "[stream1out2]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=1,select=lte(n\\,30)[stream1ending];" +
//         "[stream2out1]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=2,select=lte(n\\,60)[stream2overlaid];" +
//         "[stream2out2]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=1,select=lte(n\\,30),split=2[stream2starting][stream2ending];" +
//         "[stream3out1]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=2,select=lte(n\\,60)[stream3overlaid];" +
//         "[stream3out2]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=1,select=lte(n\\,30)[stream3starting];" +
//         "[stream2starting][stream1ending]blend=all_expr='if(gte(X,(W/2)*T/1)*lte(X,W-(W/2)*T/1),B,A)':shortest=1[stream2blended];" +
//         "[stream3starting][stream2ending]blend=all_expr='if(gte(X,(W/2)*T/1)*lte(X,W-(W/2)*T/1),B,A)':shortest=1[stream3blended];" +
//         "[stream1overlaid][stream2blended][stream2overlaid][stream3blended][stream3overlaid]concat=n=5:v=1:a=0,scale=w=640:h=424,format=yuv420p[video]\"" +
//         " -map [video] -vsync 2 -async 1 " +
//         customOptions +
//         "-c:v " +
//         videoCodec +
//         " -r 30 " +
//         videoFilePath;
//   }
//
//   static const MethodChannel _methodChannel = MethodChannel('flutter_ffmpeg');
//   static final Map<int, ExecuteCallback> executeCallbackMap = Map();
// }
//
// class _VideoScreenState extends State<VideoScreen> {
//   @override
//   Widget build(BuildContext context) {
//     print('imageList : ${widget.imageList}');
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () async {
//                 await encodeVideo();
//               },
//               child: const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(12),
//                   child: Text('Make Video'),
//                 ),
//               ),
//             ),
//
//
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.all(20.0),
//                 padding: const EdgeInsets.all(4.0),
//                 child: FutureBuilder(
//                   future: getVideoFile(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       File file = snapshot.data as File;
//                       return Container(
//                           alignment: const Alignment(0.0, 0.0),
//                           child: EmbeddedPlayer(
//                               file.path.toString()));
//                     } else {
//                       return Container(
//                         alignment: const Alignment(0.0, 0.0),
//                         decoration: BoxDecoration(
//                           color: const Color.fromRGBO(236, 240, 241, 1.0),
//                           border: Border.all(color: const Color.fromRGBO(185, 195, 199, 1.0), width: 1.0),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // getVideoFile() async {
//   //   String extension = "mp4";
//   //
//   //   final String video = "video." + extension;
//   //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
//   //   return File("${documentsDirectory.path}/$video");
//   // }
//
//   encodeVideo() {
//     // ffprint(
//     //     "Testing post execution commands before starting the new encoding.");
//     // Test.testPostExecutionCommands();
//
//     try{
//       getVideoFile().then((videoFile) {
//         // IF VIDEO IS PLAYING STOP PLAYBACK
//         // pause();
//
//         print('One');
//         try {
//           print('Two');
//           // videoFile.delete().catchError((_) {});
//         } on Exception catch (_) {}
//
//         const String videoCodec = 'libx264';
//
//         // ffprint("Testing VIDEO encoding with '$videoCodec' codec");
//         print('Three');
//         hideProgressDialog();
//         showProgressDialog();
//         print('Four');
//         final ffmpegCommand = VideoScreen.generateEncodeVideoScript(
//             widget.imageList[0],
//             widget.imageList[1],
//             widget.imageList[2],
//             videoFile.path,
//             videoCodec,
//             getCustomOptions());
//         print('Five');
//         print('ffmpegCommand : $ffmpegCommand');
//         // executeAsyncFFmpeg(ffmpegCommand,
//         //         (CompletedFFmpegExecution execution) {
//         //       // hideProgressDialog();
//         //
//         //       if (execution.returnCode == 0) {
//         //         // ffprint("Encode completed successfully; playing video.");
//         //         // playVideo();
//         //       } else {
//         //         // ffprint("Encode failed with rc=${execution.returnCode}.");
//         //         // showPopup("Encode failed. Please check log for the details.");
//         //       }
//         //     }).then((executionId) {
//         //   // ffprint(
//         //   //     "Async FFmpeg process started with arguments '$ffmpegCommand' and executionId $executionId.");
//         // });
//       });
//     } catch(e) {
//       print('Errors123 : $e');
//     }
//
//   }
//
//   getVideoFile() async {
//     String video = "video.mp4";
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     return File("${documentsDirectory.path}/$video");
//   }
//
//   getCustomOptions() {
//     return "";
//   }
//
//   Future<int> executeAsyncFFmpeg(
//       String command, ExecuteCallback executeCallback) async {
//     return await executeAsync(command, executeCallback);
//   }
//
//   Future<int> executeAsync(
//       String command, ExecuteCallback executeCallback) async {
//     return executeAsyncWithArguments(
//         FlutterFFmpeg.parseArguments(command)!, executeCallback);
//   }
//
//   Future<int> executeAsyncWithArguments(
//       List<String> arguments, ExecuteCallback executeCallback) async {
//     try {
//       return await VideoScreen._methodChannel.invokeMethod(
//           'executeFFmpegAsyncWithArguments',
//           {'arguments': arguments}).then((map) {
//         var executionId = map["executionId"];
//         VideoScreen.executeCallbackMap[executionId] = executeCallback;
//         return executionId;
//       });
//     } on PlatformException catch (e, stack) {
//       print("Plugin executeFFmpegAsyncWithArguments error: ${e.message}");
//       return Future.error("executeFFmpegAsyncWithArguments failed.", stack);
//     }
//   }
//
//   void hideProgressDialog() {
//     dialogHide();
//   }
//
//   void dialogHide() {}
//
//   late Statistics? statistics;
//
//   @override
//   void initState() {
//     statistics = null;
//     super.initState();
//   }
//
//   void showProgressDialog() {
//     // CLEAN STATISTICS
//     statistics = null;
//     resetStatistics();
//     dialogShow("Encoding video");
//   }
//
//   Future<void> resetStatistics() async {
//     return await resetStatistics1();
//   }
//
//   Future<void> resetStatistics1() async {
//     try {
//       await VideoScreen._methodChannel.invokeMethod('resetStatistics');
//     } on PlatformException catch (e) {
//       print("Plugin resetStatistics error: ${e.message}");
//     }
//   }
//
//   void dialogShow(String message) {}
// }
// */
//
// import 'package:flutter/material.dart';
// import 'modules/command_tab.dart';
// import 'modules/abstract.dart';
// import 'modules/decoration.dart';
// import 'modules/progress_modal.dart';
// import 'modules/video_tab.dart';
//
// GlobalKey _globalKey = GlobalKey();
//
// class VideoScreen extends StatefulWidget {
//   List<String> imageList;
//   VideoScreen({Key? key, required this.imageList}) : super(key: key);
//
//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }
//
// class _VideoScreenState extends State<VideoScreen> with TickerProviderStateMixin
//     implements RefreshablePlayerDialogFactory {
//
//   VideoTab videoTab = VideoTab();
//   ProgressModal? progressModal;
//   CommandTab commandTab = CommandTab();
//
//   @override
//   void initState() {
//     progressModal = ProgressModal(context);
//     videoTab.init(this);
//     videoTab.setActive();
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     print('imageList : ${widget.imageList}');
//     return Scaffold(
//       appBar: AppBar(title: const Text('Video Make'), centerTitle: true),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           /*Container(
//               padding: const EdgeInsets.symmetric(
//                   vertical: 20, horizontal: 40),
//               child: Container(
//                 width: 200,
//                 alignment: Alignment.center,
//                 decoration: dropdownButtonDecoration,
//                 child: DropdownButtonHideUnderline(
//                     child: DropdownButton(
//                       style: dropdownButtonTextStyle,
//                       value: videoTab.getSelectedCodec(),
//                       items: videoTab.getVideoCodecList(),
//                       onChanged: videoTab.changedVideoCodec,
//                       iconSize: 0,
//                       isExpanded: false,
//                     )),
//               )),*/
//           Container(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: InkWell(
//               onTap: () => videoTab.encodeVideo(widget.imageList),
//               child: Container(
//                 width: 100,
//                 height: 38,
//                 decoration: buttonDecoration,
//                 child: const Center(
//                   child: Text(
//                     'ENCODE',
//                     style: buttonTextStyle,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           /*Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(20.0),
//               padding: const EdgeInsets.all(4.0),
//               child: FutureBuilder(
//                 future: videoTab.getVideoFile(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     File file = snapshot.data as File;
//                     return Container(
//                         alignment: const Alignment(0.0, 0.0),
//                         child: EmbeddedPlayer(
//                             file.path.toString(), videoTab));
//                   } else {
//                     return Container(
//                       alignment: const Alignment(0.0, 0.0),
//                       decoration: videoPlayerFrameDecoration,
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),*/
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dialogHide() {
//     if (progressModal != null) {
//       progressModal?.hide();
//     }
//   }
//
//   @override
//   void dialogShow(String message) {
//     progressModal = ProgressModal(context);
//     progressModal?.show(message);
//   }
//
//   @override
//   void dialogShowCancellable(String message, Function cancelFunction) {
//     progressModal = ProgressModal(_globalKey.currentContext!);
//     progressModal?.show(message, cancelFunction: cancelFunction);
//   }
//
//   @override
//   void dialogUpdate(String message) {
//     progressModal?.update(message: message);
//   }
//
//   @override
//   void dispose() {
//     commandTab.dispose();
//     super.dispose();
//   }
//
//   @override
//   void refresh() {}
// }
