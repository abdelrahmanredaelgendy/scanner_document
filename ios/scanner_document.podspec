#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint scanner_document.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'scanner_document'
  s.version          = '1.1.0'
  s.summary          = 'A Flutter document scanner plugin.'
  s.description      = <<-DESC
A Flutter document scanner plugin with automatic edge detection and cropping.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Scanner Team' => 'info@scanner.com' }
  s.source           = { :path => '.' }
  # Source lives in the Swift Package layout so CocoaPods and Swift Package
  # Manager share a single copy of the code.
  s.source_files = 'scanner_document/Sources/scanner_document/**/*.swift'
  s.resources        = 'scanner_document/Sources/scanner_document/Resources/**/*',
                       'scanner_document/Sources/scanner_document/WeScan/Resources/**/*.{xcassets,strings}'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
