import 'dart:io';
import 'package:archive/archive.dart';

import 'package:dio/dio.dart';
import 'package:frpc_gui_flutter/utils/constants.dart';

import '../models/github_release/github_release.dart';

Future<void> downloadFrpc() async {
  // get github latest release json
  var response = await Dio()
      .get('https://api.github.com/repos/fatedier/frp/releases/latest');

  var githubRelease = GithubRelease.fromMap(response.data);

  var assets = githubRelease.assets;
  if (assets == null) {
    return;
  }
  // find asset with contain windows_amd64.zip
  var windowsAsset = assets
      .firstWhere((element) => element.name!.contains('windows_amd64.zip'));

  // get temp folder
  var tempDir = Directory.systemTemp;
  // download windows_amd64.zip
  await Dio()
      .download(windowsAsset.browserDownloadUrl!, "${tempDir.path}/frp.zip");

  // get file path reference
  var file = File("${tempDir.path}/frp.zip");

  // unzip file
  var zip = ZipDecoder();
  var archive = zip.decodeBytes(file.readAsBytesSync());
  for (final file in archive) {
    final filename = file.name;
    if (file.isFile && filename.endsWith("frpc.exe")) {
      final data = file.content as List<int>;
      File(frpcPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    }
  }
  // delete temp file
  file.deleteSync();
}

bool checkIfFrpcExists() {
  final fileExist = File(frpcPath).existsSync();
  return fileExist;
}
