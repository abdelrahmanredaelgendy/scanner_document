import Flutter
import UIKit

@objc(DocumentScannerPlugin)
public class DocumentScannerPlugin: NSObject, FlutterPlugin, UIApplicationDelegate {

    /// Bundle that holds the plugin's resources (e.g. the gallery icon).
    /// Swift Package Manager exposes them through `Bundle.module`, while
    /// CocoaPods copies them next to the class, reachable via `Bundle(for:)`.
    static var resourceBundle: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: DocumentScannerPlugin.self)
        #endif
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "document_scanner", binaryMessenger: registrar.messenger())
        let instance = DocumentScannerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getPictures" {
            let args = call.arguments as? Dictionary<String, Any> ?? [:]
            let scannerOptions = ScannerOptions.fromArguments(args: call.arguments)

            // Get save directory path
            let tempDirPath = getDocumentsDirectory()
            let currentDateTime = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyyMMdd-HHmmss"
            let formattedDate = df.string(from: currentDateTime)
            let saveTo = tempDirPath.appendingPathComponent(formattedDate + ".\(scannerOptions.imageFormat.rawValue)").path

            let canUseGallery = args["can_use_gallery"] as? Bool ?? false

            if let viewController = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController {
                let destinationViewController = HomeViewController()
                destinationViewController.setParams(saveTo: saveTo, canUseGallery: canUseGallery)
                destinationViewController._result = result
                destinationViewController.scannerOptions = scannerOptions
                viewController.present(destinationViewController, animated: true, completion: nil)
            }
        } else if call.method == "getPicturesFromGallery" {
            let args = call.arguments as? Dictionary<String, Any> ?? [:]
            let scannerOptions = ScannerOptions.fromArguments(args: call.arguments)

            // Get save directory path
            let tempDirPath = getDocumentsDirectory()
            let currentDateTime = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyyMMdd-HHmmss"
            let formattedDate = df.string(from: currentDateTime)
            let saveTo = tempDirPath.appendingPathComponent(formattedDate + ".\(scannerOptions.imageFormat.rawValue)").path

            if let viewController = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController {
                let destinationViewController = HomeViewController()
                destinationViewController.setParams(saveTo: saveTo, canUseGallery: false)
                destinationViewController._result = result
                destinationViewController.scannerOptions = scannerOptions
                destinationViewController.selectPhoto()
            }
        } else {
            result(FlutterMethodNotImplemented)
            return
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
