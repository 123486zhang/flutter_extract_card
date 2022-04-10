import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    //友盟统计
    UMConfigure.initWithAppkey("61cbcdc3e0f9bb492bb08fc9", channel: "App Store")
    
    //通讯
    FlutterNativePlugin.register(with: self.registrar(forPlugin: "FlutterNativePlugin")!)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
