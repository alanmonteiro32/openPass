import 'package:dartz/dartz.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/features/characters/domain/entities/character.dart';
import 'package:my_app/features/characters/domain/repositories/character_repository.dart';

class GetCharacters implements UseCase<List<Character>, NoParams> {

  GetCharacters(this.repository);
  final CharacterRepository repository;

  @override
  Future<Either<Failure, List<Character>>> call(NoParams params) {
    return repository.getCharacters();
  }
}
