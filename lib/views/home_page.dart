import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frpc_gui_flutter/controllers/frpc_controller.dart';
import 'package:frpc_gui_flutter/layouts/main_layout.dart';
import 'package:frpc_gui_flutter/models/config.dart';
import 'package:frpc_gui_flutter/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _serverAddressController =
      TextEditingController();
  final TextEditingController _serverPortController = TextEditingController();
  final TextEditingController _localPortController = TextEditingController();
  final TextEditingController _remotePortController = TextEditingController();
  String _selectedProtocol = 'tcp';

  final FrpcController _frpcController = Get.find<FrpcController>();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final serverAddress = prefs.getString('serverAddress');
    final serverPort = prefs.getInt('serverPort');
    final localPort = prefs.getInt('localPort');
    final remotePort = prefs.getInt('remotePort');
    final protocol = prefs.getString('protocol');

    if (serverAddress != null) {
      _serverAddressController.text = serverAddress;
    }
    if (serverPort != null) {
      _serverPortController.text = serverPort.toString();
    }
    if (localPort != null) {
      _localPortController.text = localPort.toString();
    }
    if (remotePort != null) {
      _remotePortController.text = remotePort.toString();
    }
    if (protocol != null) {
      setState(() {
        _selectedProtocol = protocol;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mainWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _serverAddressController,
            decoration: const InputDecoration(
              labelText: 'Server address',
            ),
          ),
          TextField(
            controller: _serverPortController,
            decoration: const InputDecoration(
              labelText: 'Server port',
            ),
          ),
          TextField(
            controller: _localPortController,
            decoration: const InputDecoration(
              labelText: 'Local port',
            ),
          ),
          TextField(
            controller: _remotePortController,
            decoration: const InputDecoration(
              labelText: 'Remote port',
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Protocol: '),
                    Radio<String>(
                      value: 'tcp',
                      groupValue: _selectedProtocol,
                      onChanged: (protocol) {
                        setState(() {
                          _selectedProtocol = protocol!;
                        });
                      },
                      fillColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                    const Text('TCP'),
                    Radio<String>(
                      value: 'udp',
                      groupValue: _selectedProtocol,
                      onChanged: (protocol) {
                        setState(() {
                          _selectedProtocol = protocol!;
                        });
                      },
                      fillColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                    const Text('UDP'),
                  ],
                ),
                // two button copy and paste from clipboard
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('Clipboard: '),
                      ElevatedButton(
                        onPressed: () async {
                          // create a FrpcConfig object
                          final config = FrpcConfig(
                            serverAddress: _serverAddressController.text,
                            serverPort: int.parse(_serverPortController.text),
                            localPort: int.parse(_localPortController.text),
                            remotePort: int.parse(_remotePortController.text),
                            protocol: _selectedProtocol,
                          );

                          await _frpcController.copyToClipboard(config: config);
                          Get.snackbar('Copied to clipboard', 'Success');
                        },
                        child: const Text('Copy'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final config =
                              await _frpcController.getConfigFromClipBoard();
                          if (config != null) {
                            _serverAddressController.text =
                                config.serverAddress;
                            _serverPortController.text =
                                config.serverPort.toString();
                            _localPortController.text =
                                config.localPort.toString();
                            _remotePortController.text =
                                config.remotePort.toString();
                            setState(() {
                              _selectedProtocol = config.protocol;
                            });
                            if (!mounted) return;
                            Get.snackbar('Pasted from clipboard', 'Success');
                          }
                        },
                        child: const Text('Paste'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // put button to the bottom
          const SizedBox(height: 15),
          Obx(
            () {
              var isLoading = _frpcController.isLoading.value;
              var isRunning = _frpcController.isRunning.value;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(70, 30),
                    backgroundColor: isLoading
                        ? Colors.yellow
                        : isRunning
                            ? Colors.red
                            : Colors.green),
                onPressed: isRunning
                    ? () => _frpcController.stop()
                    : () => _frpcController.start(
                          config: FrpcConfig(
                            serverAddress: _serverAddressController.text,
                            serverPort: int.parse(_serverPortController.text),
                            localPort: int.parse(_localPortController.text),
                            remotePort: int.parse(_remotePortController.text),
                            protocol: _selectedProtocol,
                          ),
                        ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        isRunning ? 'Stop' : 'Start',
                      ),
              );
            },
          ),
        ],
      ),
    );
    if (!isMobile) {
      return MainLayout(child: mainWidget);
    }
    return Material(child: mainWidget);
  }
}
