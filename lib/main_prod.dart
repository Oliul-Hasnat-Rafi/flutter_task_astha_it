import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_astha_it/core/services/local_storage/cache_service.dart';
import 'core/bloc/bloc_observer.dart';
import 'core/di/injection_container.dart' as di;
import 'flavors/build_config.dart';
import 'flavors/env_config.dart';
import 'flavors/env_loader.dart';
import 'flavors/environment.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvLoader.load("PROD");
  final themeMode = await CacheService.instance.retrieveTheme();
  final local = await CacheService.instance.retrieveLanguage();

  BuildConfig.instantiate(
    envType: Environment.PRODUCTION,
    envConfig: EnvConfig(
      appName: "Production",
      baseUrl: EnvLoader.baseUrl,
      googleBooksApiKey: EnvLoader.googleBooksApiKey,
      themeMode: themeMode == 'light' ? ThemeMode.light : ThemeMode.dark,
      locale: local == 'en' ? const Locale('en') : const Locale('bn'),
    ),
  );
  Bloc.observer = GlobalBlocObserver();
  await di.init();

  runApp(const MyApp());
}
