#import "DocumentScannerPlugin.h"
#if __has_include(<scanner_document/scanner_document-Swift.h>)
#import <scanner_document/scanner_document-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "scanner_document-Swift.h"
#endif

@implementation DocumentScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDocumentScannerPlugin registerWithRegistrar:registrar];
}
@end
