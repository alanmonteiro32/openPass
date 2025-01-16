import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/features/characters/domain/entities/character.dart';
import 'package:my_app/features/characters/domain/usecases/get_characters.dart';
import 'package:my_app/features/characters/domain/usecases/toggle_favorite.dart';
import 'package:my_app/features/characters/presentation/bloc/character_bloc.dart';
import 'package:my_app/features/characters/presentation/bloc/character_event.dart';
import 'package:my_app/features/characters/presentation/bloc/character_state.dart';

@GenerateMocks([GetCharacters, ToggleFavorite])
import 'character_bloc_test.mocks.dart';

void main() {
  late CharacterBloc bloc;
  late MockGetCharacters mockGetCharacters;
  late MockToggleFavorite mockToggleFavorite;

  setUp(() {
    mockGetCharacters = MockGetCharacters();
    mockToggleFavorite = MockToggleFavorite();
    bloc = CharacterBloc(
      getCharacters: mockGetCharacters,
      toggleFavorite: mockToggleFavorite,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final tCharacter = Character(
    name: 'Luke Skywalker',
    birthYear: '19BBY',
    eyeColor: 'blue',
    gender: 'male',
    hairColor: 'blond',
    height: '172',
    mass: '77',
    skinColor: 'fair',
    url: 'https://swapi.dev/api/people/1/',
    isFavorite: false,
  );

  final tCharacters = [tCharacter];

  test('initial state should be CharacterInitial', () {
    expect(bloc.state, equals(CharacterInitial()));
  });

  group('LoadCharacters', () {
    test(
      'should emit [CharacterLoading, CharacterLoaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetCharacters(any)).thenAnswer(
            (_) async => Right<Failure, List<Character>>(tCharacters));

        // assert later
        final expected = [
          CharacterLoading(),
          CharacterLoaded(characters: tCharacters),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const LoadCharacters());
      },
    );

    test(
      'should emit [CharacterLoading, CharacterError] when getting data fails',
      () async {
        // arrange
        when(mockGetCharacters(any))
            .thenAnswer((_) async => const Left(ServerFailure()));

        // assert later
        final expected = [
          CharacterLoading(),
          const CharacterError(message: 'Error del servidor'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const LoadCharacters());
      },
    );
  });

  group('SearchCharacters', () {
    setUp(() {
      when(mockGetCharacters(any)).thenAnswer(
          (_) async => Right<Failure, List<Character>>(tCharacters));
      bloc.add(const LoadCharacters());
    });

    test('should emit CharacterLoaded with filtered characters', () async {
      // Wait for LoadCharacters to complete
      await untilCalled(mockGetCharacters(any));

      // act
      bloc.add(const SearchCharacters(query: 'Luke'));

      // assert
      await expectLater(
        bloc.stream,
        emits(CharacterLoaded(
          characters: tCharacters,
          searchQuery: 'Luke',
        )),
      );
    });
  });

  group('ToggleFavoriteEvent', () {
    final updatedCharacter = tCharacter.copyWith(isFavorite: true);

    test(
      'should emit updated characters list when toggling favorite succeeds',
      () async {
        // arrange
        when(mockGetCharacters(any)).thenAnswer(
            (_) async => Right<Failure, List<Character>>(tCharacters));
        when(mockToggleFavorite(any)).thenAnswer(
            (_) async => Right<Failure, List<String>>([tCharacter.url]));

        // Load initial characters
        bloc.add(const LoadCharacters());
        await untilCalled(mockGetCharacters(any));

        // act
        bloc.add(ToggleFavoriteEvent(character: tCharacter));

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            CharacterLoaded(characters: tCharacters),
            CharacterLoaded(characters: [updatedCharacter]),
          ]),
        );
        verify(mockToggleFavorite(tCharacter.url)).called(1);
      },
    );

    test(
      'should emit CharacterError when toggling favorite fails',
      () async {
        // arrange
        when(mockGetCharacters(any)).thenAnswer(
            (_) async => Right<Failure, List<Character>>(tCharacters));
        when(mockToggleFavorite(any))
            .thenAnswer((_) async => const Left(CacheFailure()));

        // Load initial characters
        bloc.add(const LoadCharacters());
        await untilCalled(mockGetCharacters(any));

        // act
        bloc.add(ToggleFavoriteEvent(character: tCharacter));

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            CharacterLoaded(characters: tCharacters),
            const CharacterError(message: 'Error de caché'),
          ]),
        );
        verify(mockToggleFavorite(tCharacter.url)).called(1);
      },
    );
  });

  group('FilterFavorites', () {
    final favoriteCharacter = tCharacter.copyWith(isFavorite: true);
    final mixedCharacters = [tCharacter, favoriteCharacter];

    test('should emit filtered list when toggling favorite filter', () async {
      // arrange
      when(mockGetCharacters(any)).thenAnswer(
          (_) async => Right<Failure, List<Character>>(mixedCharacters));

      // Load initial characters
      bloc.add(const LoadCharacters());
      await untilCalled(mockGetCharacters(any));

      // act
      bloc.add(const FilterFavorites());

      // assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          CharacterLoaded(characters: mixedCharacters),
          CharacterLoaded(
            characters: [favoriteCharacter],
            showOnlyFavorites: true,
          ),
        ]),
      );
    });

    test('should emit unfiltered list when toggling favorite filter again',
        () async {
      // arrange
      when(mockGetCharacters(any)).thenAnswer(
          (_) async => Right<Failure, List<Character>>(mixedCharacters));

      // Load initial characters and apply filter
      bloc.add(const LoadCharacters());
      await untilCalled(mockGetCharacters(any));
      bloc.add(const FilterFavorites());

      // act
      bloc.add(const FilterFavorites());

      // assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          CharacterLoaded(characters: mixedCharacters),
          CharacterLoaded(
            characters: [favoriteCharacter],
            showOnlyFavorites: true,
          ),
          CharacterLoaded(
            characters: mixedCharacters,
            showOnlyFavorites: false,
          ),
        ]),
      );
    });
  });

  group('RefreshCharacters', () {
    test(
      'should emit new list of characters when refresh succeeds',
      () async {
        // arrange
        when(mockGetCharacters(any)).thenAnswer(
            (_) async => Right<Failure, List<Character>>(tCharacters));

        // act
        bloc.add(const RefreshCharacters());

        // assert
        await expectLater(
          bloc.stream,
          emits(CharacterLoaded(characters: tCharacters)),
        );
        verify(mockGetCharacters(NoParams())).called(1);
      },
    );

    test(
      'should emit CharacterError when refresh fails',
      () async {
        // arrange
        when(mockGetCharacters(any))
            .thenAnswer((_) async => const Left(ServerFailure()));

        // act
        bloc.add(const RefreshCharacters());

        // assert
        await expectLater(
          bloc.stream,
          emits(const CharacterError(message: 'Error del servidor')),
        );
      },
    );
  });
}
