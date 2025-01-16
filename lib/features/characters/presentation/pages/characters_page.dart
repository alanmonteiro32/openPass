import 'package:flutter/material.dart';
import 'package:my_app/features/characters/presentation/widgets/characters_appbar.dart';
import 'package:my_app/features/characters/presentation/widgets/characters_body.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CharactersAppBar(),
      ),
      body: const CharactersBody(),
    );
  }
}
