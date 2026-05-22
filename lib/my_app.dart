import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_astha_it/core/app_context.dart';
import 'package:flutter_task_astha_it/core/base/blocs/base_bloc.dart';
import 'package:flutter_task_astha_it/core/base/blocs/base_state.dart';
import 'package:flutter_task_astha_it/core/bloc/global_bloc_providers.dart';
import 'package:flutter_task_astha_it/core/localization.dart';
import 'package:flutter_task_astha_it/core/routes/route_generator.dart';
import 'package:flutter_task_astha_it/core/theme/color.schema.dart';
import 'package:flutter_task_astha_it/core/utils/transitions.dart';
import 'package:flutter_task_astha_it/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppContext.instantiate(context: context);
    return MultiBlocProvider(
        providers: GlobalBlocProviders().providers,
        child: BlocBuilder<BaseBloc, BaseState>(
          builder: (context, state) {
            return MaterialApp.router(
              supportedLocales: getSupportedLocal(),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: state.locale,
              debugShowCheckedModeBanner: false,
              themeMode: state.themeMode,
              theme:
              ThemeData(useMaterial3: true, colorScheme: lightColorScheme,
                  pageTransitionsTheme: pageTransitionsTheme),
              darkTheme:
              ThemeData(useMaterial3: true, colorScheme: darkColorScheme,
                  pageTransitionsTheme: pageTransitionsTheme),
              routerConfig: RouteGenerator.router,
            );
          },
        ));
  }
}