import 'package:get_it/get_it.dart';
import 'package:maestro/data/repository/authentication/auth_repository_impl.dart';
import 'package:maestro/data/repository/song/song_repository_impl.dart';
import 'package:maestro/data/sources/authentication/auth_firebase_service.dart';
import 'package:maestro/data/sources/song/song_firebase_service.dart';
import 'package:maestro/domain/repository/authentication/auth_repository.dart';
import 'package:maestro/domain/usecases/authentication/signup.dart';
import 'package:maestro/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:maestro/domain/usecases/song/get_news_songs_use_case.dart';
import 'package:maestro/domain/usecases/song/get_play_list.dart';
import 'package:maestro/domain/usecases/song/is_favorite_song.dart';
import 'data/repository/playlist/playlist_repository_impl.dart';
import 'data/sources/playlist/playlist_firebase_service.dart';
import 'domain/repository/playlist/playlists_repository.dart';
import 'domain/repository/song/songs_repository.dart';
import 'domain/usecases/authentication/signin.dart';
import 'domain/usecases/playlist/create_play_list_use_cases.dart';
import 'domain/usecases/playlist/get_play_list.dart';
import 'domain/usecases/playlist/is_favorite_playlist.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());

  sl.registerSingleton<SongFirebaseService>(SongFirebaseServiceImpl());

  sl.registerSingleton<PlaylistFirebaseService>(PlaylistFirebaseServiceImpl());

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  sl.registerSingleton<SongsRepository>(SongRepositoryImpl());

  sl.registerSingleton<PlaylistsRepository>(PlaylistRepositoryImpl());

  sl.registerSingleton<SignupUseCase>(SignupUseCase());

  sl.registerSingleton<SigninUseCase>(SigninUseCase());

  sl.registerSingleton<GetNewsSongsUseCase>(GetNewsSongsUseCase());

  sl.registerSingleton<GetPlayListUseCase>(GetPlayListUseCase());

  sl.registerSingleton<AddOrRemoveFavoriteSongsUseCase>(AddOrRemoveFavoriteSongsUseCase());

  sl.registerSingleton<IsFavoriteSongUseCase>(IsFavoriteSongUseCase());

  sl.registerSingleton<GetPlaylistUseCase>(GetPlaylistUseCase());

  sl.registerSingleton<CreatePlaylistUseCases>(CreatePlaylistUseCases());

  sl.registerSingleton<IsFavoritePlaylistUseCase>(IsFavoritePlaylistUseCase());
}
