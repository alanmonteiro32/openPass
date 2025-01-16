import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/features/characters/domain/entities/character.dart';
import 'package:my_app/features/characters/domain/repositories/character_repository.dart';
import 'package:my_app/features/characters/domain/usecases/get_characters.dart';

class MockCharacterRepository extends Mock implements CharacterRepository {}
class FakeNoParams extends Fake implements NoParams {}

void main() {
  late GetCharacters usecase;
  late MockCharacterRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockRepository = MockCharacterRepository();
    usecase = GetCharacters(mockRepository);
  });

  final tCharacters = [
    const Character(
      name: 'Luke Skywalker',
      birthYear: '19BBY',
      eyeColor: 'blue',
      gender: 'male',
      hairColor: 'blond',
      height: '172',
      mass: '77',
      skinColor: 'fair',
      url: 'https://swapi.dev/api/people/1/',
    ),
  ];

  test('should get characters from the repository', () async {
    // arrange
    when(() => mockRepository.getCharacters())
        .thenAnswer((_) async => Right(tCharacters));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, Right(tCharacters));
    verify(() => mockRepository.getCharacters());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(() => mockRepository.getCharacters())
        .thenAnswer((_) async => const Left(ServerFailure()));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(ServerFailure()));
    verify(() => mockRepository.getCharacters());
    verifyNoMoreInteractions(mockRepository);
  });
}