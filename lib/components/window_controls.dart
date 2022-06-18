import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:frpc_gui_flutter/controllers/frpc_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

final buttonColors = WindowButtonColors(
  iconNormal: Colors.white,
  mouseOver: const Color(0xFFF6A00C),
  mouseDown: const Color(0xFF805306),
  iconMouseOver: Colors.white,
  iconMouseDown: const Color(
    0xFFFFD500,
  ),
);

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFFD32F2F),
  mouseDown: const Color(0xFFB71C1C),
  iconNormal: Colors.white,
  iconMouseOver: Colors.white,
);

class WindowControls extends StatefulWidget {
  const WindowControls({Key? key}) : super(key: key);

  @override
  State<WindowControls> createState() => _WindowControlsState();
}

class _WindowControlsState extends State<WindowControls> {
  final FrpcController _frpcController =
      Get.put<FrpcController>(FrpcController());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // github image assets\images\github.png
        TextButton(
          onPressed: () {
            launchUrl(
                Uri.parse("https://github.com/jlucaso1/frpc_gui_flutter"));
          },
          child: Tooltip(
            message: "Made with ❤️ by jlucaso1",
            child: Image.asset(
              'assets/images/github.png',
              width: appWindow.titleBarButtonSize.width,
              height: appWindow.titleBarButtonSize.height,
            ),
          ),
          // tooltip
          //
        ),
        Tooltip(
            message: "Hide to tray",
            child: MinimizeWindowButton(
              colors: buttonColors,
              onPressed: appWindow.hide,
            )),
        // MaximizeWindowButton(colors: buttonColors),
        Tooltip(
          message: "Close",
          child: CloseWindowButton(
            colors: closeButtonColors,
            onPressed: () {
              _frpcController.stop();
              appWindow.close();
            },
          ),
        ),
      ],
    );
  }
}
