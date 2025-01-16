import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';

class MockUseCase extends Mock implements UseCase<String, NoParams> {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late MockUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockUseCase = MockUseCase();
  });

  test('NoParams should have empty props list', () {
    final noParams = NoParams();
    expect(noParams.props, isEmpty);
  });

  test('UseCase should return Right<String> on success', () async {
    when(() => mockUseCase(any()))
        .thenAnswer((_) async => const Right('success'));

    final result = await mockUseCase(NoParams());
    expect(result, equals(const Right('success')));
  });

  test('UseCase should return Left<Failure> on error', () async {
    when(() => mockUseCase(any()))
        .thenAnswer((_) async => const Left(ServerFailure()));

    final result = await mockUseCase(NoParams());
    expect(result, equals(const Left(ServerFailure())));
  });
}
