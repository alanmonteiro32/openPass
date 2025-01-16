import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/core/error/failures.dart';

void main() {
  group('Failures', () {
    test('ServerFailure props should contain message', () {
      const failure = ServerFailure(message: 'test message');
      expect(failure.props, [failure.message]);
    });

    test('NetworkFailure props should contain message', () {
      const failure = NetworkFailure(message: 'test message');
      expect(failure.props, [failure.message]);
    });

    test('CacheFailure props should contain message', () {
      const failure = CacheFailure(message: 'test message');
      expect(failure.props, [failure.message]);
    });

    test('InvalidDataFailure props should contain message', () {
      const failure = InvalidDataFailure(message: 'test message');
      expect(failure.props, [failure.message]);
    });

    test('UnexpectedFailure props should contain message', () {
      const failure = UnexpectedFailure(message: 'test message');
      expect(failure.props, [failure.message]);
    });

    test('Different failures with same message should be equal', () {
      const failure1 = ServerFailure(message: 'test');
      const failure2 = ServerFailure(message: 'test');
      expect(failure1, equals(failure2));
    });
  });
}
