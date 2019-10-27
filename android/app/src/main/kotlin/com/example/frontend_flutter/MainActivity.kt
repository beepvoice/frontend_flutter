package com.example.frontend_flutter

import android.os.Bundle
import android.util.Log
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        val peerManager = PeerManager(applicationContext)

        MethodChannel(flutterView, "beepvoice.app/conversation").setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
            when (call.method) {
                "init" -> {
                    Log.v("Conversation channel", "Init success")
                    (call.arguments as? String)?.run {
                        peerManager.initializeToken(this)
                    }
                    result.success(0)
                }
                "join" -> {
                    print("join in Kotlin")
                    (call.arguments as? String)?.run {
                        peerManager.join(this)
                    }
                    result.success(0)
                }
                "exit" -> {
                    print("exit in Kotlin")
                    peerManager.exit()
                    result.success(0)
                }
                "get" -> {
                    print("get in Kotlin")
                    result.success(peerManager.get() ?: "")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
