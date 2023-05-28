import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> getTemporaryFilePath(int index) async {
  Directory tempDir = await getApplicationDocumentsDirectory();
  String filePath = '${tempDir.path}/recording$index.aac';
  log('Complete file path: $filePath');
  return filePath;
}
