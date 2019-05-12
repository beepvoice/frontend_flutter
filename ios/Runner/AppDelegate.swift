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
    let peerManager = PeerManager()
    
    conversationChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
    
        switch call.method {
        case "join":
            if let conversationId: String = call.arguments as? String {
                peerManager.join(conversationId: conversationId)
                print("Join executed")
            }
            return
        case "exit":
            peerManager.exit()
            print("Exit executed")
            return
        case "get":
            if let activeConversation = peerManager.get() {
                result(activeConversation)
            } else {
                result("")
            }
            print("get executed")
            return
        default:
            result(FlutterMethodNotImplemented)
            return
        }
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
