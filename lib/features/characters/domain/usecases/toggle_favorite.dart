import 'package:dartz/dartz.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/features/characters/domain/repositories/character_repository.dart';

class ToggleFavorite implements UseCase<List<String>, String> {
  ToggleFavorite(this.repository);
  final CharacterRepository repository;

  @override
  Future<Either<Failure, List<String>>> call(String url) {
    return repository.toggleFavorite(url);
  }
}
