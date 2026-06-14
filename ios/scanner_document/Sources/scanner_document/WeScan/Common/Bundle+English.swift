//
//  Bundle+English.swift
//  WeScan
//
//  Force English localization for WeScan
//

import Foundation

extension Bundle {
    /// Returns English strings directly, bypassing localization
    static func weScanLocalizedString(_ key: String, value: String) -> String {
        // Always return the English value, ignoring system localization
        return value
    }
}
