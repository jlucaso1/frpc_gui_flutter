import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frpc_gui_flutter/models/config.dart';
import 'package:frpc_gui_flutter/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrpcController extends GetxController {
  var isLoading = false.obs;
  Rx<Process?> frpcProcess = Rx<Process?>(null);
  RxBool get isRunning => (frpcProcess.value != null).obs;

  void start({
    required FrpcConfig config,
  }) async {
    if (frpcProcess.value != null) return;
    isLoading.value = true;
    var tempProcess = await Process.start(await frpcPath, [
      config.protocol,
      '-s',
      '${config.serverAddress}:${config.serverPort}',
      '-l',
      '${config.localPort}',
      '-r',
      '${config.remotePort}',
    ]);
    tempProcess.stdout.transform(utf8.decoder).listen((data) async {
      // debugPrint(data);
      if (data.contains('start proxy success')) {
        frpcProcess.value = tempProcess;
        // debugPrint('started frpc.exe process, pid: ${tempProcess.pid}');
        saveConfig(config: config);
        isLoading.value = false;
        return;
      }
      if (data.contains('port already used')) {
        // debugPrint('port already used');
        // kill current proccess
        tempProcess.kill();
        // show error dialog
        Get.dialog(AlertDialog(
          title: const Text('Error'),
          content: const Text('Port already used'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Get.back();
              },
            ),
            ElevatedButton(
              child: const Text('Kill All'),
              onPressed: () async {
                // kill all processes frpc.exe
                Platform.isWindows
                    ? Process.run('taskkill', ['/f', '/im', 'frpc.exe'])
                    : Process.run('killall', ['frpc']);
                Get.back();
              },
            ),
          ],
        ));

        isLoading.value = false;
      }
    });
  }

  void stop() async {
    if (frpcProcess.value == null) return;
    frpcProcess.value?.kill();
    frpcProcess.value = null;
    isLoading.value = false;
  }

  Future<void> copyToClipboard({
    required FrpcConfig config,
  }) async {
    return Clipboard.setData(ClipboardData(text: jsonEncode(config.toJson())));
  }

  Future<FrpcConfig?> getConfigFromClipBoard() async {
    final data = await Clipboard.getData('text/plain');
    if (data == null) throw "Failed to parse clipboard";
    final json = jsonDecode(data.text.toString());
    final config = FrpcConfig.fromJson(json);

    return config;
  }

  Future<void> saveConfig({required FrpcConfig config}) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('serverAddress', config.serverAddress);
    prefs.setInt('serverPort', config.serverPort);
    prefs.setInt('localPort', config.localPort);
    prefs.setInt('remotePort', config.remotePort);
    prefs.setString('protocol', config.protocol);
  }
}
