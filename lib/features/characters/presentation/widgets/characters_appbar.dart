import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/characters/presentation/bloc/character_bloc.dart';
import 'package:my_app/features/characters/presentation/bloc/character_event.dart';
import 'package:my_app/features/characters/presentation/bloc/character_state.dart';
import 'package:my_app/features/characters/presentation/widgets/star_wars_title.dart';

class CharactersAppBar extends StatelessWidget {
  const CharactersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: AppBar(
          centerTitle: true,
          title: const StarWarsTitle(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 80,
          actions: const [FavoritesButton()],
        ),
      ),
    );
  }
}

class FavoritesButton extends StatelessWidget {
  const FavoritesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.favorite,
              color: state is CharacterLoaded && state.showOnlyFavorites
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              context.read<CharacterBloc>().add(const FilterFavorites());
            },
          ),
        );
      },
    );
  }
}