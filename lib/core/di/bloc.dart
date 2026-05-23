part of 'injection_container.dart';

Future<void> _initBlocs() async {
  sl.registerFactory(() => BaseBloc(BaseState.initial()));
  sl.registerFactory(
    () => LandingBloc(const LandingState(landingStatus: LandingStatus.initial)),
  );
  sl.registerFactory(() => BookBloc(bookUseCase: sl.call()));
  sl.registerFactory(
    () => BookDetailBloc(getBookDetailUseCase: sl.call()),
  );
}
