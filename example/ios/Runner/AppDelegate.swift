import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
    if key.hasPrefix("wescan.") {
      // Force English for WeScan
      if let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
         let bundle = Bundle(path: path) {
        return bundle.localizedString(forKey: key, value: value, table: tableName)
      }
    }
    return super.localizedString(forKey: key, value: value, table: tableName)
  }
}
