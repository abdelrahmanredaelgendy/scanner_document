import 'package:scanner_document/scanner_document.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'mocks/mock_permission_handler_platform.dart';

void main() {
  group('ScannerDocument permission denied', () {
    setUp(() {
      PermissionHandlerPlatform.instance = MockPermissionHandlerPlatform(
          permissionStatus: PermissionStatus.denied);
    });

    test('getPictures with denied permission', () async {
      expect(() async => await ScannerDocument.getPictures(),
          throwsA(isA<Exception>()));
    });
  });

  group('ScannerDocument permission permanently denied', () {
    setUp(() {
      PermissionHandlerPlatform.instance = MockPermissionHandlerPlatform(
          permissionStatus: PermissionStatus.permanentlyDenied);
    });

    test('getPictures with permanently denied permission', () async {
      expect(() async => await ScannerDocument.getPictures(),
          throwsA(isA<Exception>()));
    });
  });

  group('ScannerDocument Plugin exceptions', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      PermissionHandlerPlatform.instance = MockPermissionHandlerPlatform();
    });

    test('getPictures with MissingPluginException', () async {
      expect(() async => await ScannerDocument.getPictures(),
          throwsA(isA<MissingPluginException>()));
    });
  });

  group('ScannerDocument granted permission', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      PermissionHandlerPlatform.instance = MockPermissionHandlerPlatform();
    });

    void loadPlatformChannel(WidgetTester tester, List<String> result) {
      MethodChannel channel = const MethodChannel('document_scanner');

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) => Future.value(result),
      );
    }

    testWidgets('getPictures empty result', (WidgetTester tester) async {
      final List<String> emptyResult = [];
      loadPlatformChannel(tester, emptyResult);
      final result = await ScannerDocument.getPictures();
      expect(result, emptyResult);
    });

    testWidgets('getPictures multiple result', (WidgetTester tester) async {
      final List<String> fakeResult = ['fake_url1', 'fake_url2', 'fake_url3'];
      loadPlatformChannel(tester, fakeResult);
      final result = await ScannerDocument.getPictures();
      expect(result, fakeResult);
    });
  });
}
