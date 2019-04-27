import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let conversationChannel = FlutterMethodChannel(name: "beepvoice.app/conversation", binaryMessenger: controller)
    
    conversationChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
    
        switch call.method {
        case "join":
            print("Join executed")
            result(String(""))
            return
        case "exit":
            print("exit executed")
            result(String(""))
            return
        case "get":
            print("get executed")
            result(String("c-d73b6afa2fe3685faad28eba36d8cd0a"))
        default:
            result(FlutterMethodNotImplemented)
            return
        }
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
