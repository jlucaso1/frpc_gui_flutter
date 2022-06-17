import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:frpc_gui_flutter/providers/frpc_provider.dart';
import 'package:provider/provider.dart';

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
        MinimizeWindowButton(colors: buttonColors, onPressed: appWindow.hide),
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
