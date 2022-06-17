import 'package:flutter/material.dart';
import 'package:frpc_gui_flutter/layouts/main_layout.dart';
import 'package:frpc_gui_flutter/utils/frp_utils.dart';

class DownloadFrpcPage extends StatefulWidget {
  const DownloadFrpcPage({Key? key}) : super(key: key);

  @override
  State<DownloadFrpcPage> createState() => _DownloadFrpcPageState();
}

class _DownloadFrpcPageState extends State<DownloadFrpcPage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return MainLayout(
        child: Center(
      // oops, apparently you don't have frpc.exe in your project
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Oops, you don\'t have frpc.exe in your project'),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 50),
            ),
            child: loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text('Download frpc.exe'),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              try {
                await downloadFrpc();
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/home');
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: Text(e.toString()),
                    actions: [
                      ElevatedButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              } finally {
                setState(() {
                  loading = false;
                });
              }
            },
          ),
        ],
      ),
    ));
  }
}
