import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/features/characters/domain/entities/character.dart';
import 'package:my_app/features/characters/domain/repositories/character_repository.dart';
import 'package:my_app/features/characters/domain/usecases/toggle_favorite.dart';

class MockCharacterRepository extends Mock implements CharacterRepository {}

void main() {
  late ToggleFavorite usecase;
  late MockCharacterRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(Character(
      name: 'Test Character',
      isFavorite: false,
      birthYear: 'unknown',
      eyeColor: 'unknown',
      gender: 'unknown',
      hairColor: 'unknown',
      height: 'unknown',
      mass: 'unknown',
      skinColor: 'unknown',
      url: 'https://test.com',
    ));
  });

  setUp(() {
    mockRepository = MockCharacterRepository();
    usecase = ToggleFavorite(mockRepository);
  });

  final tCharacter = Character(
    name: 'Luke Skywalker',
    birthYear: '19BBY',
    eyeColor: 'blue',
    gender: 'male',
    hairColor: 'blond',
    height: '172',
    mass: '77',
    skinColor: 'fair',
    url: 'https://swapi.dev/api/people/1/',
    isFavorite: false,
  );

  test('should toggle favorite status through the repository', () async {
    // arrange
    when(() => mockRepository.toggleFavorite(tCharacter.url))
        .thenAnswer((_) async => Right([tCharacter.url]));

    // act
    final result = await usecase(tCharacter.url);

    // assert
    expect(result, result.fold((l) => l, (r) => Right(r)));
    verify(() => mockRepository.toggleFavorite(tCharacter.url));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(() => mockRepository.toggleFavorite(any()))
        .thenAnswer((_) async => const Left(CacheFailure()));

    // act
    final result = await usecase(tCharacter.url);

    // assert
    expect(result, const Left(CacheFailure()));
    verify(() => mockRepository.toggleFavorite(tCharacter.url));
    verifyNoMoreInteractions(mockRepository);
  });
}
