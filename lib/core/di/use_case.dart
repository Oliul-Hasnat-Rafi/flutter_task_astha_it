part of 'injection_container.dart';

Future<void> _initUseCases() async {
  sl.registerLazySingleton(() => BookUseCase(bookRepository: sl.call()));
  sl.registerLazySingleton(() => GetBookDetailUseCase(repository: sl.call()));
}
