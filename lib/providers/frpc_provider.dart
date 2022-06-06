import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frpc_gui_flutter/models/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrpcProvider extends ChangeNotifier {
  Process? frpcProcess;

  bool get isRunning => frpcProcess != null;

  void start({
    required String serverAddress,
    required int serverPort,
    required int localPort,
    required int remotePort,
    required String protocol,
    required BuildContext context,
  }) async {
    if (frpcProcess != null) return;
    var tempProcess = await Process.start('frpc.exe', [
      protocol,
      '-s',
      '$serverAddress:$serverPort',
      '-l',
      '$localPort',
      '-r',
      '$remotePort',
    ]);
    tempProcess.stdout.transform(utf8.decoder).listen((data) async {
      // debugPrint(data);
      if (data.contains('start proxy success')) {
        frpcProcess = tempProcess;
        // debugPrint('started frpc.exe process, pid: ${tempProcess.pid}');
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();

        prefs.setString('serverAddress', serverAddress);
        prefs.setInt('serverPort', serverPort);
        prefs.setInt('localPort', localPort);
        prefs.setInt('remotePort', remotePort);
        prefs.setString('protocol', protocol);
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
      }
    });
  }

  void stop() async {
    if (frpcProcess == null) return;
    frpcProcess?.kill();
    frpcProcess = null;
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
}
