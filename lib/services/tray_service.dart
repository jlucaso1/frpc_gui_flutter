import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:frpc_gui_flutter/controllers/frpc_controller.dart';
import 'package:get/get.dart';
import 'package:tray_manager/tray_manager.dart';

class TrayService extends GetxService with TrayListener {
  final _frpcController = Get.find<FrpcController>();
  final _menu = Menu(items: [
    MenuItem(
      key: 'exit_app',
      label: 'Exit App',
    ),
  ]);

  @override
  void onReady() {
    super.onReady();
    trayManager.addListener(this);
    _initTray();
  }

  void _initTray() async {
    await trayManager.setIcon('assets/images/app_icon.ico');
    await trayManager.setContextMenu(_menu);
    await trayManager.setTitle('Frpc GUI');
    if (!Platform.isLinux) {
      await trayManager.setToolTip('Frpc GUI');
    }
  }

  @override
  void onClose() {
    trayManager.removeListener(this);
    trayManager.destroy();
    super.onClose();
  }

  @override
  void onTrayIconMouseDown() {
    appWindow.show();
  }

  @override
  void onTrayIconMouseUp() {}

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() {}

  void addShowMenuItem() {
    _menu.items?.add(
      MenuItem(
        key: 'show_app',
        label: 'Show App',
      ),
    );
    trayManager.setContextMenu(_menu);
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'exit_app') {
      appWindow.close();
      _frpcController.stop();
    }
    if (menuItem.key == 'show_app') {
      appWindow.show();
      // remove tray icon with key 'show_app'
      _menu.items?.removeWhere((element) => element.key == 'show_app');
      trayManager.setContextMenu(_menu);
    }
  }
}
