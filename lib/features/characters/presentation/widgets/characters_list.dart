import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/characters/domain/entities/character.dart';
import 'package:my_app/features/characters/presentation/bloc/character_bloc.dart';
import 'package:my_app/features/characters/presentation/bloc/character_event.dart';
import 'package:my_app/features/characters/presentation/bloc/character_state.dart';
import 'package:my_app/features/characters/presentation/widgets/characters_card.dart';
import 'package:my_app/features/characters/presentation/widgets/star_wars_dialog.dart';
import 'package:my_app/features/characters/presentation/widgets/star_wars_loader.dart';

class CharactersList extends StatelessWidget {
  const CharactersList({
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      onRefresh: () async {
        context.read<CharacterBloc>().add(const RefreshCharacters());
        return Future<void>.delayed(const Duration(milliseconds: 1500));
      },
      child: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading) {
            return const StarWarsLoader();
          } else if (state is CharacterLoaded) {
            return state.characters.isEmpty
                ? EmptyStateWidget(
                    constraints: constraints,
                    searchQuery: state.searchQuery,
                  )
                : CharactersListView(characters: state.characters);
          } else if (state is CharacterError) {
            return ErrorStateWidget(
              constraints: constraints,
              message: state.message,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.constraints,
    required this.searchQuery,
  });

  final BoxConstraints constraints;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Text(
              searchQuery.isEmpty
                  ? 'No characters available'
                  : 'No characters match "$searchQuery"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.constraints,
    required this.message,
  });

  final BoxConstraints constraints;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CharactersListView extends StatelessWidget {
  const CharactersListView({
    super.key,
    required this.characters,
  });

  final List<Character> characters;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return CharacterCard(
          character: character,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => StarWarsDialog(
                title: character.name,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _DetailRow(label: 'Height', value: character.height),
                    _DetailRow(label: 'Mass', value: character.mass),
                    _DetailRow(label: 'Hair Color', value: character.hairColor),
                    _DetailRow(label: 'Skin Color', value: character.skinColor),
                    _DetailRow(label: 'Eye Color', value: character.eyeColor),
                    _DetailRow(label: 'Birth Year', value: character.birthYear),
                    _DetailRow(label: 'Gender', value: character.gender),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
