import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:my_app/features/characters/data/dto/character_dto.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late CharacterRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = CharacterRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(Uri.parse('https://swapi.py4e.com/api/people/'));
  });

  group('getCharacters', () {
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

    test('should perform a GET request on a URL', () async {
      // arrange
      when(() => mockHttpClient.get(any()))
          .thenAnswer((_) async => http.Response(
                jsonEncode({
                  'results': [tCharacterDTO.toJson()]
                }),
                200,
              ));

      // act
      await dataSource.getCharacters();

      // assert
      verify(() => mockHttpClient.get(
            Uri.parse('https://swapi.py4e.com/api/people/'),
          )).called(1);
    });

    test('should return List<CharacterDTO> when the response code is 200',
        () async {
      // arrange
      when(() => mockHttpClient.get(any()))
          .thenAnswer((_) async => http.Response(
                jsonEncode({
                  'results': [tCharacterDTO.toJson()]
                }),
                200,
              ));

      // act
      final result = await dataSource.getCharacters();

      // assert
      expect(result, equals([tCharacterDTO]));
    });

    test('should throw a ServerFailure when the response code is not 200',
        () async {
      // arrange
      when(() => mockHttpClient.get(any()))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      // act
      final call = dataSource.getCharacters;

      // assert
      expect(
        () => call(),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('should throw a ServerFailure when the response is not valid JSON',
        () async {
      // arrange
      when(() => mockHttpClient.get(any()))
          .thenAnswer((_) async => http.Response('Invalid JSON', 200));

      // act
      final call = dataSource.getCharacters;

      // assert
      expect(
        () => call(),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('should throw a ServerFailure when network error occurs', () async {
      // arrange
      when(() => mockHttpClient.get(any())).thenThrow(Exception());

      // act
      final call = dataSource.getCharacters;

      // assert
      expect(
        () => call(),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
