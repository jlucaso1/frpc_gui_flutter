import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frpc_gui_flutter/models/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrpcProvider extends ChangeNotifier {
  Process? frpcProcess;

  bool get isRunning => frpcProcess != null;

  bool isLoading = false;

  void start({
    required FrpcConfig config,
    required BuildContext context,
  }) async {
    if (frpcProcess != null) return;
    isLoading = true;
    notifyListeners();
    var tempProcess = await Process.start('frp/frpc.exe', [
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
        frpcProcess = tempProcess;
        // debugPrint('started frpc.exe process, pid: ${tempProcess.pid}');
        saveConfig(config: config);
        isLoading = false;
        notifyListeners();
        return;
      }
      if (data.contains('port already used')) {
        // debugPrint('port already used');
        // kill current proccess
        tempProcess.kill();
        // show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Port already used'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Kill All'),
                onPressed: () async {
                  // kill all processes frpc.exe
                  Process.run('taskkill', ['/f', '/im', 'frpc.exe']);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        isLoading = false;
        notifyListeners();
      }
    });
  }

  void stop() async {
    if (frpcProcess == null) return;
    frpcProcess?.kill();
    frpcProcess = null;
    isLoading = false;
    notifyListeners();
  }

  Future<void> copyToClipboard(
      {required FrpcConfig config, required BuildContext context}) async {
    return Clipboard.setData(ClipboardData(text: jsonEncode(config.toJson())));
  }

  Future<FrpcConfig?> getConfigFromClipBoard(BuildContext context) async {
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
