import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_astha_it/core/di/injection_container.dart' as di;
import 'package:flutter_task_astha_it/features/landing/presentation/blocs/landing_bloc.dart';
import 'package:flutter_task_astha_it/features/book/presentation/bloc/home_bloc.dart';

import '../base/blocs/base_bloc.dart';

class GlobalBlocProviders {
  dynamic providers = [
    BlocProvider(create: (_) => di.sl<BaseBloc>()),
    BlocProvider(create: (_) => di.sl<LandingBloc>()),
    BlocProvider(create: (_) => di.sl<BookBloc>()),
  ];
}
