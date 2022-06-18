import 'package:frpc_gui_flutter/controllers/frpc_controller.dart';
import 'package:frpc_gui_flutter/services/tray_service.dart';
import 'package:get/get.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FrpcController>(FrpcController());
    Get.put<TrayService>(TrayService());
  }
}
