import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/characters/presentation/bloc/character_bloc.dart';
import 'package:my_app/features/characters/presentation/bloc/character_event.dart';
import 'package:my_app/features/characters/presentation/bloc/character_state.dart';
import 'package:my_app/features/characters/presentation/widgets/characters_list.dart';
import 'package:my_app/features/characters/presentation/widgets/star_wars_search_bar.dart';

class CharactersContent extends StatelessWidget {
  const CharactersContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                const SearchBarWidget(),
                Expanded(
                  child: CharactersList(constraints: constraints),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, -0.5),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: state is CharacterLoaded && !state.showOnlyFavorites
              ? StarWarsSearchBar(
                  key: const ValueKey('searchBar'),
                  onChanged: (value) {
                    context
                        .read<CharacterBloc>()
                        .add(SearchCharacters(query: value));
                  },
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        );
      },
    );
  }
}
