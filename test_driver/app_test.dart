// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('ログイン処理', () {
    final signupTextFinder = find.byValueKey('signup');

    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('新規登録', () async {
      expect(await driver.getText(signupTextFinder), "新規登録");
    });
  });
}
