package com.example.frpc_gui_flutter

// import frpc.Frpc

import android.util.Log
import androidx.annotation.NonNull
import frpclib.Frpclib
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
  private val CHANNEL = "frp/frpc"

  private fun frpcRun(): Int {
    Frpclib.run("frpc.ini")
    Log.d("frpc", "frpcRun")
    return 0
  }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        // This method is invoked on the main thread.
        call,
        result ->
      if (call.method == "connect") {
        val code = frpcRun()

        if (code != -1) {
          result.success(code)
        } else {
          result.error("UNAVAILABLE", "Battery level not available.", null)
        }
      } else {
        result.notImplemented()
      }
    }
  }
}
