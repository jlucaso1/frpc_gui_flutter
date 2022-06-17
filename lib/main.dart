import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:frpc_gui_flutter/app.dart';

void main() async {
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
