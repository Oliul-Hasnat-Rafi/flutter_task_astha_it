import 'package:go_router/go_router.dart';
import 'package:flutter_task_astha_it/core/routes/error_screen.dart';
import 'package:flutter_task_astha_it/core/routes/routes.dart';
import 'package:flutter_task_astha_it/features/landing/presentation/pages/landing_screen.dart';
import 'package:flutter_task_astha_it/features/settings/presentation/pages/settings_screen.dart';
import 'package:flutter_task_astha_it/features/book/presentation/page/book_screen.dart';
import 'package:flutter_task_astha_it/features/book/presentation/page/book_details_page.dart';
import 'package:flutter_task_astha_it/features/book/data/model/res_model/book_model.dart';


class RouteGenerator {
  static final GoRouter router = GoRouter(
    errorBuilder: (context, state) {
      return const ErrorPage();
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) {
          return "/${Routes.landing}";
        },
      ),
      GoRoute(
        name: Routes.landing,
        path: "/${Routes.landing}",
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        name: Routes.book,
        path: "/${Routes.book}",
        builder: (context, state) => const BookScreen(),
      ),
      GoRoute(
        name: Routes.bookDetails,
        path: "/${Routes.bookDetails}/:bookId",
        builder: (context, state) {
          final book = state.extra as BookModel?;
          if (book == null) {
            return const ErrorPage();
          }
          return BookDetailsPage(book: book);
        },
      ),
      GoRoute(
        name: Routes.settings,
        path: "/${Routes.settings}",
        builder: (context, state) =>  SettingsScreen(),
      ),
    ],
  );
}
