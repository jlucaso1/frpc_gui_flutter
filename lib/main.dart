import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:frpc_gui_flutter/providers/frpc_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(640, 360);
    const minSize = Size(640, 360);
    win.minSize = minSize;
    win.maxSize = minSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Frpc GUI";
    win.show();
  });
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
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: WindowBorder(
      color: Colors.deepPurple,
      width: 1,
      child: Column(
        children: [
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8, top: 4),
                        child: Text(
                          "Frpc GUI",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      MoveWindow(),
                    ],
                  ),
                ),
                const WindowButtons()
              ],
            ),
          ),
          const MainWidget(),
        ],
      ),
    ));
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  late FrpcProvider _frpcProvider;

  @override
  void initState() {
    super.initState();
    _frpcProvider = Provider.of<FrpcProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        // MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(
          colors: closeButtonColors,
          onPressed: () {
            _frpcProvider.stop();
            appWindow.close();
          },
        ),
      ],
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  final TextEditingController _serverAddressController =
      TextEditingController();
  final TextEditingController _serverPortController = TextEditingController();
  final TextEditingController _localPortController = TextEditingController();
  final TextEditingController _remotePortController = TextEditingController();
  String _selectedProtocol = 'tcp';

  late FrpcProvider _frpcProvider;

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
    return Padding(
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
                ),
                const Text('UDP'),
              ],
            ),
          ),
          // put button to the bottom
          const SizedBox(height: 20),
          Consumer<FrpcProvider>(builder: (context, provider, child) {
            var isRunning = provider.isRunning;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(90, 40),
                  primary: isRunning ? Colors.red : Colors.green),
              onPressed: provider.isRunning
                  ? () => _frpcProvider.stop()
                  : () => _frpcProvider.start(
                      serverAddress: _serverAddressController.text,
                      serverPort: int.parse(_serverPortController.text),
                      localPort: int.parse(_localPortController.text),
                      remotePort: int.parse(_remotePortController.text),
                      protocol: _selectedProtocol,
                      context: context),
              child: Text(
                isRunning ? 'Stop' : 'Start',
              ),
            );
          }),
        ],
      ),
    );
  }
}
