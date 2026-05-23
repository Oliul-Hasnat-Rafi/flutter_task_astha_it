import 'package:get_it/get_it.dart';
import 'package:flutter_task_astha_it/core/base/blocs/base_bloc.dart';
import 'package:flutter_task_astha_it/core/base/blocs/base_state.dart';
import 'package:flutter_task_astha_it/features/landing/presentation/blocs/landing_bloc.dart';

import '../../features/book/data/datasource/book_datasource.dart';
import '../../features/book/data/datasource/book_datasource_imp.dart';
import '../../features/book/data/repository/book_repo_imp.dart';
import '../../features/book/domain/repositories/book_repositories.dart';
import '../../features/book/domain/use_cases/book_use_case.dart';
import '../../features/book/presentation/bloc/home_bloc.dart';
import '../../features/landing/presentation/blocs/landing_state.dart';

import '../network/rest_client.dart';

part 'bloc.dart';
part 'data_source.dart';
part 'repository.dart';
part 'use_case.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Bloc
  await _initBlocs();

  /// UseCase
  await _initUseCases();

  /// Repository
  await _initRepositories();

  /// Datasource
  await _initDataSources();

  /// Network
  final restClient = RestClient();
  sl.registerLazySingleton(
    () => restClient,
  );
}
