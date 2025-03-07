import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:maestro/routes/app_routes.dart';
import 'package:maestro/service_locator.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import 'package:maestro/utils/devices/device_utility.dart';
import 'package:maestro/utils/theme/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'bindings/general_bindings.dart';
import 'data/sources/notification/notification_service.dart';
import 'features/choose_mode/bloc/theme_cubit.dart';
import 'features/library/bloc/language_cubit.dart';
import 'features/library/controllers/themes_controller.dart';
import 'features/song_player/widgets/mini_player/mini_player_manager.dart';
import 'features/song_player/widgets/task/audio_player_task.dart';
import 'features/splash/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'generated/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/song_player/bloc/song_player_cubit.dart';

/// Initialize application dependencies and services
Future<void> initApp() async {
  /// -- Widget Binding
  WidgetsFlutterBinding.ensureInitialized();

  /// -- Hydrated Bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorageDirectory.web : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  /// Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDependencies();

  /// -- GetX Local Storage
  await GetStorage.init();

  /// -- Initialize GeneralBindings which contains all necessary dependencies
  GeneralBindings().dependencies();

  /// -- Set system UI status bar color globally
  DeviceUtils.setStatusBarColor(AppColors.transparent);

  /// -- Initialize NotificationService and AudioPlayerTask
  final notificationService = NotificationService();
  final audioPlayerTask = AudioPlayerTask();

  Get.put(notificationService);
  Get.put(audioPlayerTask);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemesController themesController = Get.put(ThemesController());

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => SongPlayerCubit()),
      ],
      child: BlocListener<ThemeCubit, ThemeMode>(
        listener: (context, themeMode) {
          themesController.setThemes(themeMode == ThemeMode.light ? 'light' : themeMode == ThemeMode.dark ? 'dark' : 'system');
        },
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return BlocBuilder<LanguageCubit, Locale>(
              builder: (context, locale) {
                return MiniPlayerManager(
                  hideMiniPlayerOnSplash: true,
                  child: GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    themeMode: themesController.getThemeMode(),
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    initialBinding: GeneralBindings(),
                    getPages: AppRoutes.pages,
                    locale: locale,
                    localizationsDelegates: const [
                      AppLocalizationDelegate(),
                      ...GlobalMaterialLocalizations.delegates,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('ru'),
                      Locale('en'),
                      Locale('es'),
                    ],
                    home: const SplashScreen(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
