// Not required for test files
// ignore_for_file: prefer_const_constructors
import 'package:inboxiq/inboxiq.dart';
import 'package:test/test.dart';

void main() {
  group('Inboxiq', () {
    test('can be instantiated', () {
      expect(Inboxiq(), isNotNull);
    });
  });
}
