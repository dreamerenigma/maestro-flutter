import 'package:get_it/get_it.dart';
import 'package:maestro/data/repository/authentication/auth_repository_impl.dart';
import 'package:maestro/data/repository/concerts/concert_repository_impl.dart';
import 'package:maestro/data/repository/song/song_repository_impl.dart';
import 'package:maestro/data/repository/station/station_repository_impl.dart';
import 'package:maestro/data/repository/user/user_repository_impl.dart';
import 'package:maestro/data/services/station/station_firebase_service.dart';
import 'package:maestro/data/services/user/user_firebase_service.dart';
import 'package:maestro/domain/repository/authentication/auth_repository.dart';
import 'package:maestro/domain/repository/comment/comment_repository.dart';
import 'package:maestro/domain/repository/concerts/concerts_repository.dart';
import 'package:maestro/domain/repository/station/station_repository.dart';
import 'package:maestro/domain/repository/users/user_repository.dart';
import 'package:maestro/domain/usecases/authentication/signup.dart';
import 'package:maestro/domain/usecases/concerts/get_concerts_use_cases.dart';
import 'package:maestro/domain/usecases/playlist/update_playlist_use_cases.dart';
import 'package:maestro/domain/usecases/song/add_or_remove_favorite_song_use_cases.dart';
import 'package:maestro/domain/usecases/song/delete_song_use_cases.dart';
import 'package:maestro/domain/usecases/song/get_news_songs_use_case.dart';
import 'package:maestro/domain/usecases/song/get_song_use_cases.dart';
import 'package:maestro/domain/usecases/song/is_favorite_song_use_cases.dart';
import 'package:maestro/domain/usecases/song/update_song_use_cases.dart';
import 'package:maestro/domain/usecases/station/create_station_use_cases.dart';
import 'data/repository/comment/comment_repository_impl.dart';
import 'data/repository/playlist/playlist_repository_impl.dart';
import 'data/services/authentication/auth_firebase_service.dart';
import 'data/services/messages/comment_service.dart';
import 'data/services/playlist/playlist_firebase_service.dart';
import 'data/services/song/song_firebase_service.dart';
import 'domain/repository/playlist/playlists_repository.dart';
import 'domain/repository/song/songs_repository.dart';
import 'domain/usecases/authentication/signin.dart';
import 'domain/usecases/comment/add_comment_use_cases.dart';
import 'domain/usecases/comment/delete_comment_use_cases.dart';
import 'domain/usecases/playlist/create_play_list_use_cases.dart';
import 'domain/usecases/playlist/delete_playlist_use_cases.dart';
import 'domain/usecases/playlist/get_play_list_use_cases.dart';
import 'domain/usecases/playlist/is_favorite_playlist_use_cases.dart';
import 'domain/usecases/user/create_recommended_tracks_use_case.dart';
import 'domain/usecases/user/get_recommended_tracks_use_case.dart';
import 'domain/usecases/user/get_user_details_use_cases.dart';
import 'domain/usecases/user/update_user_details_use_cases.dart';
import 'domain/usecases/user/update_user_preferences_use_cases.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  /// -- Firebase Service Impl --
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<SongFirebaseService>(SongFirebaseServiceImpl());
  sl.registerSingleton<PlaylistFirebaseService>(PlaylistFirebaseServiceImpl());
  sl.registerSingleton<UserFirebaseService>(UserFirebaseServiceImpl());
  sl.registerSingleton<StationFirebaseService>(StationFirebaseServiceImpl());
  sl.registerSingleton<CommentFirebaseService>(CommentFirebaseServiceImpl());

  /// -- Repository Impl --
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SongsRepository>(SongRepositoryImpl());
  sl.registerSingleton<PlaylistsRepository>(PlaylistRepositoryImpl());
  sl.registerSingleton<UserRepository>(UserRepositoryImpl());
  sl.registerSingleton<ConcertsRepository>(ConcertRepositoryImpl());
  sl.registerSingleton<StationRepository>(StationRepositoryImpl());
  sl.registerSingleton<CommentRepository>(CommentRepositoryImpl());

  /// -- Authentication Use Cases --
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());

  /// -- Song Use Cases --
  sl.registerSingleton<GetNewsSongsUseCase>(GetNewsSongsUseCase());
  sl.registerSingleton<GetSongUseCase>(GetSongUseCase());
  sl.registerSingleton<AddOrRemoveFavoriteSongsUseCase>(AddOrRemoveFavoriteSongsUseCase());
  sl.registerSingleton<UpdateSongUseCases>(UpdateSongUseCases());
  sl.registerSingleton<DeleteSongUseCases>(DeleteSongUseCases());
  sl.registerSingleton<IsFavoriteSongUseCase>(IsFavoriteSongUseCase());

  /// -- Playlist Use Cases --
  sl.registerSingleton<GetPlaylistUseCase>(GetPlaylistUseCase());
  sl.registerSingleton<CreatePlaylistUseCases>(CreatePlaylistUseCases());
  sl.registerSingleton<UpdatePlaylistUseCases>(UpdatePlaylistUseCases());
  sl.registerSingleton<DeletePlaylistUseCases>(DeletePlaylistUseCases());
  sl.registerSingleton<IsFavoritePlaylistUseCase>(IsFavoritePlaylistUseCase());

  /// -- User Use Cases --
  sl.registerSingleton<GetUserDetailsUseCases>(GetUserDetailsUseCases());
  sl.registerSingleton<UpdateUserDetailsUseCases>(UpdateUserDetailsUseCases());
  sl.registerSingleton<UpdateUserPreferencesUseCases>(UpdateUserPreferencesUseCases());
  sl.registerSingleton<GetRecommendedTracksUseCase>(GetRecommendedTracksUseCase());
  sl.registerSingleton<CreateRecommendedTracksUseCase>(CreateRecommendedTracksUseCase());

  /// -- Concert Use Cases --
  sl.registerSingleton<GetConcertsUseCase>(GetConcertsUseCase());

  /// -- Station Use Cases --
  sl.registerSingleton<CreateStationUseCases>(CreateStationUseCases());

  /// -- Comment Use Cases --
  sl.registerSingleton<AddCommentUseCases>(AddCommentUseCases());
  sl.registerSingleton<DeleteCommentUseCases>(DeleteCommentUseCases());
}
