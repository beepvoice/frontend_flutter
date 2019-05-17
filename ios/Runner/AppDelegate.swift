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
        case "init":
            if let authToken: String = call.arguments as? String {
                peerManager.initializeToken(authToken: authToken)
            }
            result(0)
            return
        case "join":
            if let conversationId: String = call.arguments as? String {
                peerManager.join(conversationId: conversationId)
            }
            result(0)
            return
        case "exit":
            peerManager.exit()
            result(0)
            return
        case "get":
            if let activeConversation = peerManager.get() {
                result(activeConversation)
            } else {
                result("")
            }
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
