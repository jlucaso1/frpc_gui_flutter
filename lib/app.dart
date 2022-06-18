import 'package:flutter/material.dart' hide MenuItem;
import 'package:frpc_gui_flutter/bindings/home_page_binding.dart';
import 'package:frpc_gui_flutter/views/download_frpc_page.dart';
import 'package:frpc_gui_flutter/views/home_page.dart';
import 'package:frpc_gui_flutter/views/splash_page.dart';
import 'package:get/get.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Frpc GUI',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashPage(),
      getPages: [
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: HomePageBinding(),
        ),
        GetPage(name: '/download', page: () => const DownloadFrpcPage()),
      ],
      debugShowCheckedModeBanner: false,
      // dark theme with deep purple primary color
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
