part of 'injection_container.dart';

Future<void> _initRepositories() async {
  sl.registerLazySingleton<BookRepository>(
    () => BookRepoImp(bookDatasource: sl.call()),
  );
}
