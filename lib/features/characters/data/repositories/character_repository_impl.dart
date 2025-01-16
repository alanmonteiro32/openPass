import 'package:dartz/dartz.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/features/characters/data/datasources/character_local_datasource.dart';
import 'package:my_app/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:my_app/features/characters/data/mapper/character_mapper.dart';
import 'package:my_app/features/characters/domain/entities/character.dart';
import 'package:my_app/features/characters/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<Character>>> getCharacters() async {
    try {
      final characterDTOs = await remoteDataSource.getCharacters();
      final favorites = await localDataSource.getFavorites();

      final characters = characterDTOs.map((dto) {
        return CharacterMapper.toEntity(
          dto,
          isFavorite: favorites.contains(dto.url),
        );
      }).toList();

      return Right(characters);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> toggleFavorite(String url) async {
    try {
      await localDataSource.toggleFavorite(url);
      final favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
