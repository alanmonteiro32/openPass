import 'package:my_app/features/characters/data/dto/character_dto.dart';
import 'package:my_app/features/characters/domain/entities/character.dart';

class CharacterMapper {
  static Character toEntity(CharacterDTO dto, {bool isFavorite = false}) {
    return Character(
      name: dto.name,
      birthYear: dto.birthYear,
      eyeColor: dto.eyeColor,
      gender: dto.gender,
      hairColor: dto.hairColor,
      height: dto.height,
      mass: dto.mass,
      skinColor: dto.skinColor,
      url: dto.url,
      isFavorite: isFavorite,
    );
  }

  static CharacterDTO fromEntity(Character entity) {
    return CharacterDTO(
      name: entity.name,
      birthYear: entity.birthYear,
      eyeColor: entity.eyeColor,
      gender: entity.gender,
      hairColor: entity.hairColor,
      height: entity.height,
      mass: entity.mass,
      skinColor: entity.skinColor,
      url: entity.url,
    );
  }
}
