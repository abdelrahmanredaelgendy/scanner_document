//
//  ScannerOptions.swift
//  document_scanner
//
//  Created by Maurits van Beusekom on 15/10/2024.
//

import Foundation

enum ScannerImageFormat: String {
    case jpg
    case png
}

struct ScannerOptions {
    let imageFormat: ScannerImageFormat
    let jpgCompressionQuality: Double

    init() {
        self.imageFormat = ScannerImageFormat.png
        self.jpgCompressionQuality = 1.0
    }

    init(imageFormat: ScannerImageFormat) {
        self.imageFormat = imageFormat
        self.jpgCompressionQuality = 1.0
    }

    init(imageFormat: ScannerImageFormat, jpgCompressionQuality: Double) {
        self.imageFormat = imageFormat
        self.jpgCompressionQuality = jpgCompressionQuality
    }

    static func fromArguments(args: Any?) -> ScannerOptions {
        if (args == nil) {
            return ScannerOptions()
        }

        let arguments = args as? Dictionary<String, Any>

        if arguments == nil || arguments!.keys.contains("iosScannerOptions") == false {
            return ScannerOptions()
        }

        let scannerOptionsDict = arguments!["iosScannerOptions"] as! Dictionary<String, Any>
        let imageFormat: String = (scannerOptionsDict["imageFormat"] as? String) ?? "png"
        let jpgCompressionQuality: Double = (scannerOptionsDict["jpgCompressionQuality"] as? Double) ?? 1.0

        return ScannerOptions(imageFormat: ScannerImageFormat(rawValue: imageFormat) ?? ScannerImageFormat.png, jpgCompressionQuality: jpgCompressionQuality)
    }
}
