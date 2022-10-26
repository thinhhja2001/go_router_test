import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:test_go_router/cubits/cubit/login_cubit.dart';
import 'package:test_go_router/screens/category_screen.dart';
import 'package:test_go_router/screens/login_screen.dart';
import 'package:test_go_router/screens/product_list_screen.dart';

class AppRouter {
  final LoginCubit loginCubit;
  AppRouter(this.loginCubit);

  late final GoRouter router = GoRouter(
      debugLogDiagnostics: true,
      routes: <GoRoute>[
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: '/',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const CategoryScreen();
          },
          routes: [
            GoRoute(
              path: 'product_list/:category',
              name: 'product_list',
              builder: (BuildContext context, GoRouterState state) {
                return ProductListScreen(
                  category: state.params['category']!,
                  asc: state.queryParams['sort'] == 'asc',
                  quantity: int.parse(
                    state.queryParams['filter'] ?? '0',
                  ),
                );
              },
            ),
          ],
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        // Check if the user is logged in
        bool loggedIn = loginCubit.state.status == AuthStatus.authenticated;
        // Check if the user is logging in.
        final bool loggingIn = state.subloc == '/login';
        if (!loggedIn) {
          return loggingIn ? null : '/login';
        }
      },
      refreshListenable: GoRouterRefreshStream(loginCubit.stream));
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
