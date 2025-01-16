import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_app/features/characters/domain/entities/character.dart';

part 'character_state.freezed.dart';

@freezed
class CharacterState with _$CharacterState {
  const factory CharacterState.initial() = CharacterInitial;
  const factory CharacterState.loading() = CharacterLoading;
  const factory CharacterState.loaded({
    required List<Character> characters,
    @Default(false) bool showOnlyFavorites,
    @Default('') String searchQuery,
  }) = CharacterLoaded;
  const factory CharacterState.error({
    required String message,
  }) = CharacterError;
}
