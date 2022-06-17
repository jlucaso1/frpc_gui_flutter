import 'package:flutter/material.dart';
import 'package:frpc_gui_flutter/layouts/main_layout.dart';
import 'package:frpc_gui_flutter/utils/frp_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
      var exists = checkIfFrpcExists();
      if (exists) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/download');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Frpc GUI is loading...'),
          SizedBox(height: 16),
          CircularProgressIndicator(),
        ],
      ),
    ));
  }
}
