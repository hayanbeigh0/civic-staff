import 'dart:developer';
import 'dart:io';

import 'package:video_compress/video_compress.dart';

class VideoCompressApi {
  static Future<MediaInfo?> compressVideo(File file) async {
    try {
      await VideoCompress.setLogLevel(0);
      log(VideoCompress.compressProgress$.toString());
      return VideoCompress.compressVideo(
        file.path,
        deleteOrigin: true,
        includeAudio: true,
        quality: VideoQuality.LowQuality,
        frameRate: 5,
      );
    } catch (e) {
      VideoCompress.cancelCompression();
    }
  }
}
