## 1.0.10
* Removed OpenCV dependencies completely from Android implementation.
* Reverted to ML Kit document scanner for better stability.
* Updated Android build dependencies (Gradle 8.7.0, AGP 8.6.0, Kotlin 2.1.0).
* Simplified document corner detection with manual adjustment support.
* Improved build compatibility and reduced package size.

## 1.0.9
* Fixed 16KB page size support by switching to opencv-android package.
* Implemented auto-capture functionality using OpenCV document detection.
* Added AutoCaptureDetector for stable document detection.
* Auto-capture triggers when document is stable for consistent frames.
* Improved document detection stability and accuracy.

## 1.0.8
* Added support for Android 16KB page size.
* Added NDK ABI filters for all supported architectures.
* Created gradle.properties for plugin configuration.
* Enabled BuildConfig feature for better compatibility.

## 1.0.7
* Fixed missing AndroidX dependencies (appcompat and core-ktx).
* Added androidx.appcompat:appcompat:1.7.0 dependency.
* Added androidx.core:core-ktx:1.13.1 dependency.

## 1.0.6
* Replaced Google ML Kit document scanner with OpenCV 4.10.0 for edge detection.
* Implemented custom document corner detection using OpenCV algorithms (Canny edge detection, contour finding).
* Removed dependency on com.google.android.gms:play-services-mlkit-document-scanner.
* Improved document edge detection accuracy with advanced image processing techniques.

## 1.0.5
* Version bump for package updates.

## 1.0.4
* Version bump for package updates.

## 1.0.3
* Version bump for internal updates.

## 1.0.2
* Documentation improvements.

## 1.0.1
* Added Xcode 15 fix instructions to README for WeScan pod configuration.
* Fixed documentation references for IosImageFormat enum.

## 1.0.0
* Initial major release.
* Updated package identifiers from biz.cunning to com.scanner.
* Enhanced API documentation with comprehensive dartdoc comments.
* Updated documentation and repository references.

