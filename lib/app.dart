import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:frpc_gui_flutter/providers/frpc_provider.dart';
import 'package:frpc_gui_flutter/views/download_frpc_page.dart';
import 'package:frpc_gui_flutter/views/home_page.dart';
import 'package:frpc_gui_flutter/views/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:tray_manager/tray_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TrayListener {
  var frpcProvider = FrpcProvider();
  final _menu = Menu(items: [
    MenuItem(
      key: 'exit_app',
      label: 'Exit App',
    ),
  ]);

  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
    _initTray();
  }

  void _initTray() async {
    await trayManager.setIcon('assets/images/app_icon.ico');
    await trayManager.setContextMenu(_menu);
    await trayManager.setToolTip('Frpc GUI');
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconMouseDown() {
    appWindow.restore();
  }

  @override
  void onTrayIconMouseUp() {}

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() {}

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'exit_app') {
      appWindow.close();
      frpcProvider.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FrpcProvider>(
          create: (_) => frpcProvider,
        ),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Frpc GUI',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashPage(),
        routes: {
          '/home': (context) => const HomePage(),
          '/download': (context) => const DownloadFrpcPage(),
        },
        debugShowCheckedModeBanner: false,
        // dark theme with deep purple primary color
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
