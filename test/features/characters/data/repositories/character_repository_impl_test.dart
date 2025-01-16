import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/features/characters/data/datasources/character_local_datasource.dart';
import 'package:my_app/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:my_app/features/characters/data/dto/character_dto.dart';
import 'package:my_app/features/characters/data/repositories/character_repository_impl.dart';
import 'package:my_app/features/characters/domain/entities/character.dart';

import 'character_repository_impl_test.mocks.dart';

@GenerateMocks([CharacterRemoteDataSource, CharacterLocalDataSource])
void main() {
  late CharacterRepositoryImpl repository;
  late CharacterRemoteDataSource mockRemoteDataSource;
  late CharacterLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockCharacterRemoteDataSource();
    mockLocalDataSource = MockCharacterLocalDataSource();
    repository = CharacterRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tCharacterDTO = [
    {
      'name': 'Luke Skywalker',
      'birth_year': '19BBY',
      'eye_color': 'blue',
      'gender': 'male',
      'hair_color': 'blond',
      'height': '172',
      'mass': '77',
      'skin_color': 'fair',
      'url': 'https://swapi.dev/api/people/1/',
    }
  ];

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

  group('getCharacters', () {
    test(
      'should return list of characters when the call to remote data source is successful',
      () async {
        // arrange
        final listCharacterDTO =
            tCharacterDTO.map((e) => CharacterDTO.fromJson(e)).toList();
        when(mockRemoteDataSource.getCharacters())
            .thenAnswer((_) async => listCharacterDTO);
        when(mockLocalDataSource.getFavorites()).thenAnswer((_) async => []);

        // act
        final result = await repository.getCharacters();

        // assert
        verify(mockRemoteDataSource.getCharacters());
        verify(mockLocalDataSource.getFavorites());
        expect(result, result.fold((l) => l, (data) => Right(data)));
      },
    );

    test(
      'should return characters with favorite status when URLs match',
      () async {
        // arrange
        final listCharacterDTO =
            tCharacterDTO.map((e) => CharacterDTO.fromJson(e)).toList();
        when(mockRemoteDataSource.getCharacters())
            .thenAnswer((_) async => listCharacterDTO);
        when(mockLocalDataSource.getFavorites()).thenAnswer(
            (_) async => listCharacterDTO.map((e) => e.url).toList());

        // act
        final result = await repository.getCharacters();

        // assert
        verify(mockRemoteDataSource.getCharacters());
        verify(mockLocalDataSource.getFavorites());
        expect(result, result.fold((l) => l, (data) => Right(data)));
      },
    );

    test(
      'should return ServerFailure when remote data source throws an exception',
      () async {
        // arrange
        when(mockRemoteDataSource.getCharacters()).thenThrow(Exception());

        // act
        final result = await repository.getCharacters();

        // assert
        verify(mockRemoteDataSource.getCharacters());
        expect(result, const Left(ServerFailure()));
      },
    );
  });

  group('toggleFavorite', () {
    test(
      'should return updated favorites list when toggling favorite is successful',
      () async {
        // arrange
        final expectedFavorites = [tCharacter.url];
        when(mockLocalDataSource.toggleFavorite(tCharacter.url))
            .thenAnswer((_) async => true);
        when(mockLocalDataSource.getFavorites())
            .thenAnswer((_) async => expectedFavorites);

        // act
        final result = await repository.toggleFavorite(tCharacter.url);

        // assert
        verify(mockLocalDataSource.toggleFavorite(tCharacter.url));
        verify(mockLocalDataSource.getFavorites());
        expect(result, equals(Right(expectedFavorites)));
      },
    );

    test(
      'should return CacheFailure when local data source throws an exception',
      () async {
        // arrange

        when(mockLocalDataSource.toggleFavorite(tCharacter.url))
            .thenThrow(Exception());

        // act
        final result = await repository.toggleFavorite(tCharacter.url);

        // assert
        verify(mockLocalDataSource.toggleFavorite(tCharacter.url));
        expect(result, equals(const Left(CacheFailure())));
      },
    );
  });
}
