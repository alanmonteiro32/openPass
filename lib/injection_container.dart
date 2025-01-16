import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/features/characters/data/datasources/character_local_datasource.dart';
import 'package:my_app/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:my_app/features/characters/data/repositories/character_repository_impl.dart';
import 'package:my_app/features/characters/domain/repositories/character_repository.dart';
import 'package:my_app/features/characters/domain/usecases/get_characters.dart';
import 'package:my_app/features/characters/domain/usecases/toggle_favorite.dart';
import 'package:my_app/features/characters/presentation/bloc/character_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerLazySingleton(() => http.Client());

  // Data sources
  sl.registerLazySingleton<CharacterLocalDataSource>(
    () => CharacterLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(client: sl()),
  );

  // Repository
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCharacters(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));

  // Bloc
  sl.registerFactory(() => CharacterBloc(
        getCharacters: sl(),
        toggleFavorite: sl(),
      ));
}
