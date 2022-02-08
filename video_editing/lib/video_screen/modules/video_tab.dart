/*
 * Copyright (c) 2020 Taner Sener
 *
 * This file is part of FlutterFFmpeg.
 *
 * FlutterFFmpeg is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * FlutterFFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with FlutterFFmpeg.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/completed_ffmpeg_execution.dart';
import 'package:flutter_ffmpeg/log.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';
import 'abstract.dart';
import 'flutter_ffmpeg_api_wrapper.dart';
import 'player.dart';
import 'popup.dart';
import 'test_api.dart';
import 'tooltip.dart';
import 'util.dart';
import 'video_util.dart';


class VideoTab implements PlayerTab {
  VideoPlayerController? _videoPlayerController;
  RefreshablePlayerDialogFactory _refreshablePlayerDialogFactory = RefreshablePlayerDialogFactory();
  String _selectedCodec = '';
  late Statistics? _statistics;

  void init(RefreshablePlayerDialogFactory refreshablePlayerDialogFactory) {
    _refreshablePlayerDialogFactory = refreshablePlayerDialogFactory;
    List<DropdownMenuItem<String>> videoCodecList = getVideoCodecList();
    _selectedCodec = videoCodecList[0].value!;
    _statistics = null;
  }

  void setActive() {
    print("Video Tab Activated");
    enableLogCallback(logCallback);
    enableStatisticsCallback(statisticsCallback);
    showPopup(VIDEO_TEST_TOOLTIP_TEXT);
  }

  void logCallback(Log log) {
    ffprint(log.message);
  }

  void statisticsCallback(Statistics statistics) {
    this._statistics = statistics;
    updateProgressDialog();
  }

  void changedVideoCodec(String? selectedCodec) {
    _selectedCodec = selectedCodec!;
    _refreshablePlayerDialogFactory.refresh();
  }

  void encodeVideo(List<String> imageList) {
    ffprint(
        "Testing post execution commands before starting the new encoding.");
    Test.testPostExecutionCommands();

    VideoUtil.assetPath(VideoUtil.ASSET_1).then((image1Path) {
      VideoUtil.assetPath(VideoUtil.ASSET_2).then((image2Path) {
        VideoUtil.assetPath(VideoUtil.ASSET_3).then((image3Path) {
          getVideoFile().then((videoFile) {
            // IF VIDEO IS PLAYING STOP PLAYBACK
            pause();

            // try {
            //   videoFile.delete().catchError((_) {});
            // } on Exception catch (_) {}

            final String videoCodec = getSelectedVideoCodec();

            ffprint("Testing VIDEO encoding with '$videoCodec' codec");

            hideProgressDialog();
            showProgressDialog();

            // final ffmpegCommand = VideoUtil.generateEncodeVideoScript(
            //     imageList[0],
            //     imageList[1],
            //     imageList[2],
            //     videoFile.path,
            //     videoCodec,
            //     getCustomOptions());

            final ffmpegCommand = VideoUtil.generateCreateVideoWithPipesScript(
                imageList[0], imageList[1], imageList[2], videoFile.path
            );

            // final ffmpegCommand = VideoUtil.generateShakingVideoScript(
            //     imageList[0], imageList[1], imageList[2], videoFile.path
            // );

            executeAsyncFFmpeg(ffmpegCommand,
                (CompletedFFmpegExecution execution) {
              hideProgressDialog();

              if (execution.returnCode == 0) {
                ffprint("Encode completed successfully; playing video.");
                GallerySaver.saveVideo(videoFile.path);
                Fluttertoast.showToast(msg: 'Video Saved In Gallery');
                playVideo();
              } else {
                ffprint("Encode failed with rc=${execution.returnCode}.");
                showPopup("Encode failed. Please check log for the details.");
              }
            }).then((executionId) {
              ffprint(
                  "Async FFmpeg process started with arguments '$ffmpegCommand' and executionId $executionId.");
            });
          });
        });
      });
    });
  }

  Future<void> playVideo() async {
    if (_videoPlayerController != null) {
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.play();
    }
    _refreshablePlayerDialogFactory.refresh();
  }

  Future<void> pause() async {
    if (_videoPlayerController != null) {
      await _videoPlayerController!.pause();
    }
    _refreshablePlayerDialogFactory.refresh();
  }

  String getSelectedVideoCodec() {
    String videoCodec = _selectedCodec;

    // VIDEO CODEC MENU HAS BASIC NAMES, FFMPEG NEEDS LONGER LIBRARY NAMES.
    // APPLYING NECESSARY TRANSFORMATION HERE
    switch (videoCodec) {
      case "x264":
        videoCodec = "libx264";
        break;
      case "openh264":
        videoCodec = "libopenh264";
        break;
      case "x265":
        videoCodec = "libx265";
        break;
      case "xvid":
        videoCodec = "libxvid";
        break;
      case "vp8":
        videoCodec = "libvpx";
        break;
      case "vp9":
        videoCodec = "libvpx-vp9";
        break;
      case "aom":
        videoCodec = "libaom-av1";
        break;
      case "kvazaar":
        videoCodec = "libkvazaar";
        break;
      case "theora":
        videoCodec = "libtheora";
        break;
    }

    return videoCodec;
  }

  Future<File> getVideoFile() async {
    String videoCodec = _selectedCodec;

    String extension;
    switch (videoCodec) {
      case "vp8":
      case "vp9":
        extension = "webm";
        break;
      case "aom":
        extension = "mkv";
        break;
      case "theora":
        extension = "ogv";
        break;
      case "hap":
        extension = "mov";
        break;
      default:
        // mpeg4, x264, x265, xvid, kvazaar
        extension = "mp4";
        break;
    }
    DateTime time = DateTime.now();

    final String video = "video_maker_${time.hour}_${time.minute}_${time.second}." + extension;
    Directory documentsDirectory = await VideoUtil.documentsDirectory;
    return File("${documentsDirectory.path}/$video");
  }

  String getCustomOptions() {
    String videoCodec = _selectedCodec;

    switch (videoCodec) {
      case "x265":
        return "-crf 28 -preset fast ";
      case "vp8":
        return "-b:v 1M -crf 10 ";
      case "vp9":
        return "-b:v 2M ";
      case "aom":
        return "-crf 30 -strict experimental ";
      case "theora":
        return "-qscale:v 7 ";
      case "hap":
        return "-format hap_q ";
      default:
        // kvazaar, mpeg4, x264, xvid
        return "";
    }
  }

  List<DropdownMenuItem<String>> getVideoCodecList() {
    List<DropdownMenuItem<String>> list = List.empty(growable: true);

    list.add(const DropdownMenuItem(
        value: "mpeg4",
        child: SizedBox(width: 100, child: Center(child: Text("mpeg4")))));
    list.add(const DropdownMenuItem(
        value: "x264",
        child: SizedBox(width: 100, child: Center(child: Text("x264")))));
    list.add(const DropdownMenuItem(
        value: "openh264",
        child:
            SizedBox(width: 100, child: Center(child: Text("openh264")))));
    list.add(const DropdownMenuItem(
        value: "x265",
        child: SizedBox(width: 100, child: Center(child: Text("x265")))));
    list.add(const DropdownMenuItem(
        value: "xvid",
        child: SizedBox(width: 100, child: Center(child: Text("xvid")))));
    list.add(const DropdownMenuItem(
        value: "vp8",
        child: SizedBox(width: 100, child: Center(child: Text("vp8")))));
    list.add(const DropdownMenuItem(
        value: "vp9",
        child: SizedBox(width: 100, child: Center(child: Text("vp9")))));
    list.add(const DropdownMenuItem(
        value: "aom",
        child: SizedBox(width: 100, child: Center(child: Text("aom")))));
    list.add(const DropdownMenuItem(
        value: "kvazaar",
        child:
            SizedBox(width: 100, child: Center(child: Text("kvazaar")))));
    list.add(const DropdownMenuItem(
        value: "theora",
        child: SizedBox(width: 100, child: Center(child: Text("theora")))));
    list.add(const DropdownMenuItem(
        value: "hap",
        child: SizedBox(width: 100, child: Center(child: Text("hap")))));

    return list;
  }

  void showProgressDialog() {
    // CLEAN STATISTICS
    _statistics = null;
    resetStatistics();
    _refreshablePlayerDialogFactory.dialogShow("Encoding video");
  }

  void updateProgressDialog() {
    var statistics = this._statistics;
    if (statistics == null) {
      return;
    }

    int timeInMilliseconds = statistics.time;
    if (timeInMilliseconds > 0) {
      int totalVideoDuration = 9000;

      int completePercentage = (timeInMilliseconds * 100) ~/ totalVideoDuration;

      _refreshablePlayerDialogFactory
          .dialogUpdate("Encoding video % $completePercentage");
      _refreshablePlayerDialogFactory.refresh();
    }
  }

  void hideProgressDialog() {
    _refreshablePlayerDialogFactory.dialogHide();
  }

  String getSelectedCodec() => _selectedCodec;

  @override
  void setController(VideoPlayerController controller) {
    _videoPlayerController = controller;
  }
}
