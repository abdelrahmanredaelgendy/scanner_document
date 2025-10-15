import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ios_options.dart';

export 'ios_options.dart';

/// A Flutter plugin for scanning documents with automatic edge detection and cropping.
///
/// This plugin provides document scanning functionality for both Android and iOS platforms.
/// On Android, it uses ML Kit for document detection. On iOS, it uses VisionKit's
/// document scanner.
///
/// Example usage:
/// ```dart
/// final images = await DocumentScanner.getPictures();
/// ```
class DocumentScanner {
  static const MethodChannel _channel =
      MethodChannel('document_scanner');

  /// Starts the document scanning workflow and returns a list of file paths to the scanned images.
  ///
  /// The [noOfPages] parameter limits the number of pages that can be scanned (Android only).
  /// Default is 100 pages.
  ///
  /// The [isGalleryImportAllowed] parameter allows users to import images from the gallery
  /// instead of taking new photos (Android only). Default is false.
  ///
  /// The [iosScannerOptions] parameter configures iOS-specific options like image format
  /// and JPEG compression quality (iOS only).
  ///
  /// Returns a list of file paths to the scanned document images, or null if the user
  /// cancels the operation.
  ///
  /// Throws an [Exception] if camera permission is not granted.
  ///
  /// Example:
  /// ```dart
  /// // Simple usage
  /// final images = await DocumentScanner.getPictures();
  ///
  /// // Android with custom options
  /// final images = await DocumentScanner.getPictures(
  ///   noOfPages: 5,
  ///   isGalleryImportAllowed: true,
  /// );
  ///
  /// // iOS with JPEG format
  /// final images = await DocumentScanner.getPictures(
  ///   iosScannerOptions: IosScannerOptions(
  ///     imageFormat: IosImageFormat.jpg,
  ///     jpgCompressionQuality: 0.8,
  ///   ),
  /// );
  /// ```
  static Future<List<String>?> getPictures({
    int noOfPages = 100,
    bool isGalleryImportAllowed = false,
    IosScannerOptions? iosScannerOptions,
  }) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied) ||
        statuses.containsValue(PermissionStatus.permanentlyDenied)) {
      throw Exception("Permission not granted");
    }

    final List<dynamic>? pictures = await _channel.invokeMethod('getPictures', {
      'noOfPages': noOfPages,
      'isGalleryImportAllowed': isGalleryImportAllowed,
      if (iosScannerOptions != null)
        'iosScannerOptions': {
          'imageFormat': iosScannerOptions.imageFormat.name,
          'jpgCompressionQuality': iosScannerOptions.jpgCompressionQuality,
        }
    });
    return pictures?.map((e) => e as String).toList();
  }
}
