import 'dart:io';
import 'package:archive/archive.dart';

import 'package:dio/dio.dart';
import 'package:frpc_gui_flutter/models/github_release/github_release.dart';
import 'package:frpc_gui_flutter/utils/constants.dart';

Future<void> downloadFrpc() async {
  if (Platform.isWindows) {
    return await downloadFrpcWindows();
  } else if (Platform.isLinux) {
    return await downloadFrpcLinux();
  }

  throw Exception('Unsupported platform');
}

bool checkIfFrpcExists() {
  final fileExist = File(frpcPath).existsSync();
  return fileExist;
}

Future<void> downloadFrpcWindows() async {
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

Future<void> downloadFrpcLinux() async {
  // get github latest release json
  var response = await Dio()
      .get('https://api.github.com/repos/fatedier/frp/releases/latest');

  var githubRelease = GithubRelease.fromMap(response.data);

  var assets = githubRelease.assets;
  if (assets == null) {
    return;
  }

  // find asset with contain linux_amd64.tar.gz
  var linuxAsset = assets
      .firstWhere((element) => element.name!.contains('linux_amd64.tar.gz'));

  // get temp folder
  var tempDir = Directory.systemTemp;
  // download linux_amd64.tar.gz
  await Dio()
      .download(linuxAsset.browserDownloadUrl!, "${tempDir.path}/frp.tar.gz");

  // get file path reference
  var tempFile = File("${tempDir.path}/frp.tar.gz");
  // unzip file
  var tarBytes = GZipDecoder().decodeBytes(tempFile.readAsBytesSync());
  var archive = TarDecoder().decodeBytes(tarBytes);

  for (final file in archive) {
    final filename = file.name;
    if (file.isFile && filename.endsWith(frpcExecutable)) {
      final data = file.content as List<int>;
      File(frpcPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    }
  }

  // delete temp file

  tempFile.deleteSync();

  // give permission to frpc
  Process.runSync('chmod', ['+x', frpcPath]);
}
