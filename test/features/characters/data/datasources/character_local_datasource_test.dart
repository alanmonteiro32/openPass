import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/features/characters/data/datasources/character_local_datasource.dart';
import 'package:my_app/features/characters/data/dto/character_dto.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late CharacterLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = CharacterLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getFavorites', () {
    test('should return empty list when no favorites are stored', () async {
      // arrange
      when(() => mockSharedPreferences.getStringList(any()))
          .thenReturn(null);

      // act
      final result = await dataSource.getFavorites();

      // assert
      verify(() => mockSharedPreferences.getStringList('FAVORITES_KEY'));
      expect(result, equals([]));
    });

    test('should return list of favorites when they exist', () async {
      // arrange
      final tFavorites = ['url1', 'url2'];
      when(() => mockSharedPreferences.getStringList(any()))
          .thenReturn(tFavorites);

      // act
      final result = await dataSource.getFavorites();

      // assert
      verify(() => mockSharedPreferences.getStringList('FAVORITES_KEY'));
      expect(result, equals(tFavorites));
    });
  });

  group('toggleFavorite', () {
    final tCharacterDTO = CharacterDTO(
      name: 'Luke Skywalker',
      birthYear: '19BBY',
      eyeColor: 'blue',
      gender: 'male',
      hairColor: 'blond',
      height: '172',
      mass: '77',
      skinColor: 'fair',
      url: 'https://swapi.dev/api/people/1/',
    );

    test('should add URL to favorites when not present', () async {
      // arrange
      when(() => mockSharedPreferences.getStringList(any()))
          .thenReturn([]);
      when(() => mockSharedPreferences.setStringList(any(), any()))
          .thenAnswer((_) async => true);

      // act
      final result = await dataSource.toggleFavorite(tCharacterDTO.url);

      // assert
      verify(() => mockSharedPreferences.setStringList(
            'FAVORITES_KEY',
            [tCharacterDTO.url],
          ));
      expect(result, equals(true));
    });

    test('should remove URL from favorites when already present', () async {
      // arrange
      when(() => mockSharedPreferences.getStringList(any()))
          .thenReturn([tCharacterDTO.url]);
      when(() => mockSharedPreferences.setStringList(any(), any()))
          .thenAnswer((_) async => true);

      // act
      final result = await dataSource.toggleFavorite(tCharacterDTO.url);

      // assert
      verify(() => mockSharedPreferences.setStringList(
            'FAVORITES_KEY',
            [],
          ));
      expect(result, equals(true));
    });
  });
}