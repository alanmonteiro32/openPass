import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_app/features/characters/domain/entities/character.dart';

part 'character_event.freezed.dart';

@freezed
class CharacterEvent with _$CharacterEvent {
  const factory CharacterEvent.load() = LoadCharacters;
  const factory CharacterEvent.search({
    required String query,
  }) = SearchCharacters;
  const factory CharacterEvent.toggleFavorite({
    required Character character,
  }) = ToggleFavoriteEvent;
  const factory CharacterEvent.filterFavorites() = FilterFavorites;
  const factory CharacterEvent.refresh() = RefreshCharacters;
}
