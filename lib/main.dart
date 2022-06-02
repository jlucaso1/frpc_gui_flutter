import 'package:flutter/material.dart';
import 'package:frpc_gui_flutter/providers/frpc_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FrpcProvider>(
          create: (_) => FrpcProvider(),
        ),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Frpc GUI',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyHomePage(title: 'Frpc GUI'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FrpcProvider _frpcProvider;

  final TextEditingController _serverAddressController =
      TextEditingController();
  final TextEditingController _serverPortController = TextEditingController();
  final TextEditingController _localPortController = TextEditingController();
  final TextEditingController _remotePortController = TextEditingController();
  String _selectedProtocol = 'tcp';

  @override
  void initState() {
    super.initState();
    _frpcProvider = Provider.of<FrpcProvider>(context, listen: false);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _serverAddressController,
                            decoration: const InputDecoration(
                              labelText: 'Server Address',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _serverPortController,
                            decoration: const InputDecoration(
                              labelText: 'Server Port',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _localPortController,
                            decoration: const InputDecoration(
                              labelText: 'Local Port',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _remotePortController,
                            decoration: const InputDecoration(
                              labelText: 'Remote Port',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButton(
                      value: _selectedProtocol,
                      items: const [
                        DropdownMenuItem(
                          value: 'tcp',
                          child: Text('tcp'),
                        ),
                        DropdownMenuItem(
                          value: 'udp',
                          child: Text('udp'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedProtocol = value.toString();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    // make a toggle button
                    Consumer<FrpcProvider>(builder: (context, provider, child) {
                      return ElevatedButton(
                        onPressed: provider.isRunning
                            ? () => _frpcProvider.stop()
                            : () => _frpcProvider.start(
                                serverAddress: _serverAddressController.text,
                                serverPort:
                                    int.parse(_serverPortController.text),
                                localPort: int.parse(_localPortController.text),
                                remotePort:
                                    int.parse(_remotePortController.text),
                                protocol: _selectedProtocol,
                                context: context),
                        child: Text(
                          provider.isRunning ? 'Stop' : 'Start',
                        ),
                      );
                    }),
                  ],
                ),
              ),
              // footer
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Created by: jlucaso',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
