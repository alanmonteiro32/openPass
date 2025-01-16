import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/features/characters/domain/entities/character.dart';
import 'package:my_app/features/characters/domain/usecases/get_characters.dart';
import 'package:my_app/features/characters/domain/usecases/toggle_favorite.dart';
import 'package:my_app/features/characters/presentation/bloc/character_event.dart';
import 'package:my_app/features/characters/presentation/bloc/character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  CharacterBloc({
    required this.getCharacters,
    required this.toggleFavorite,
  }) : super(const CharacterState.initial()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<SearchCharacters>(_onSearchCharacters);
    on<ToggleFavoriteEvent>(_onToggleFavoriteEvent);
    on<FilterFavorites>(_onFilterFavorites);
    on<RefreshCharacters>(_onRefreshCharacters);
  }

  final GetCharacters getCharacters;
  final ToggleFavorite toggleFavorite;
  List<Character> _allCharacters = [];

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    emit(const CharacterState.loading());
    final result = await getCharacters(NoParams());

    result.fold(
      (failure) =>
          emit(CharacterState.error(message: _mapFailureToMessage(failure))),
      (characters) {
        _allCharacters = characters;
        emit(CharacterState.loaded(characters: characters));
      },
    );
  }

  void _onSearchCharacters(
    SearchCharacters event,
    Emitter<CharacterState> emit,
  ) {
    if (state is CharacterLoaded) {
      final currentState = state as CharacterLoaded;
      final filteredCharacters = _allCharacters.where((character) {
        return character.name.toLowerCase().contains(event.query.toLowerCase());
      }).toList();

      emit(CharacterState.loaded(
        characters: filteredCharacters,
        searchQuery: event.query,
        showOnlyFavorites: currentState.showOnlyFavorites,
      ));
    }
  }

  Future<void> _onToggleFavoriteEvent(
    ToggleFavoriteEvent event,
    Emitter<CharacterState> emit,
  ) async {
    if (state is CharacterLoaded) {
      final currentState = state as CharacterLoaded;
      final result = await toggleFavorite(event.character.url);

      await result.fold(
        (failure) async =>
            emit(CharacterError(message: _mapFailureToMessage(failure))),
        (updatedCharacter) async {
          final index = _allCharacters
              .indexWhere((character) => character.url == event.character.url);
          _allCharacters[index] = _allCharacters[index]
              .copyWith(isFavorite: !event.character.isFavorite);

          final filteredCharacters = _filterCharacters(
            currentState.showOnlyFavorites,
          );

          emit(CharacterLoaded(
            characters: filteredCharacters,
            showOnlyFavorites: currentState.showOnlyFavorites,
          ));
        },
      );
    }
  }

  void _onFilterFavorites(
    FilterFavorites event,
    Emitter<CharacterState> emit,
  ) {
    if (state is CharacterLoaded) {
      final currentState = state as CharacterLoaded;
      final showOnlyFavorites = !currentState.showOnlyFavorites;
      final filteredCharacters = _filterCharacters(showOnlyFavorites);

      emit(CharacterLoaded(
        characters: filteredCharacters,
        showOnlyFavorites: showOnlyFavorites,
      ));
    }
  }

  Future<void> _onRefreshCharacters(
    RefreshCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    final result = await getCharacters(NoParams());

    await result.fold(
      (failure) async =>
          emit(CharacterError(message: _mapFailureToMessage(failure))),
      (characters) async {
        _allCharacters = characters;
        if (state is CharacterLoaded) {
          final currentState = state as CharacterLoaded;
          final filteredCharacters = _filterCharacters(
            currentState.showOnlyFavorites,
          );
          emit(CharacterLoaded(
            characters: filteredCharacters,
            showOnlyFavorites: currentState.showOnlyFavorites,
          ));
        } else {
          emit(CharacterLoaded(characters: characters));
        }
      },
    );
  }

  List<Character> _filterCharacters(bool showOnlyFavorites) {
    return _allCharacters.where((character) {
      return showOnlyFavorites ? character.isFavorite : true;
    }).toList();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Error del servidor';
      case NetworkFailure:
        return 'Error de conexión';
      case CacheFailure:
        return 'Error de caché';
      default:
        return 'Error inesperado';
    }
  }
}
