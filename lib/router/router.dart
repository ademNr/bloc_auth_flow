import 'package:bloc_auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:bloc_auth/bloc/auth_bloc/auth_state.dart';
import 'package:bloc_auth/router/routes.dart';
import 'package:bloc_auth/screens/auth/login_screen.dart';
import 'package:bloc_auth/screens/home/home_screen.dart';
import 'package:bloc_auth/screens/loading_screen.dart';
import 'package:bloc_auth/screens/another_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutes.loading,
    routes: [
      GoRoute(
        path: AppRoutes.loading,
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.another,
        builder: (context, state) => const AnotherScreen(),
      ),
    ],
    errorPageBuilder: (context, state) => const MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text('Route not found!'),
        ),
      ),
    ),
    redirect: (context, state) {
      final authStatus = context.read<AuthBloc>().state;

      if (authStatus is AuthAuthenticated &&
          (state.fullPath == AppRoutes.login ||
              state.fullPath == AppRoutes.loading)) {
        return AppRoutes.home;
      }

      if (authStatus is AuthUnauthenticated &&
          (state.fullPath == AppRoutes.loading ||
              state.fullPath == AppRoutes.home)) {
        return AppRoutes.login;
      }

      return null;
    },
  );
}
