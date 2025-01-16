import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/features/characters/data/dto/character_dto.dart';

abstract class CharacterRemoteDataSource {
  Future<List<CharacterDTO>> getCharacters();
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  CharacterRemoteDataSourceImpl({required this.client});
  final http.Client client;
  final String baseUrl = 'https://swapi.py4e.com/api';

  @override
  Future<List<CharacterDTO>> getCharacters() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/people/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        return results
            .map((json) => CharacterDTO.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }
}
