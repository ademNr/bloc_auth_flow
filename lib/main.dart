import 'package:bloc_auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:bloc_auth/bloc/auth_bloc/auth_event.dart';
import 'package:bloc_auth/bloc/auth_bloc/auth_state.dart';
import 'package:bloc_auth/bloc/login_bloc/login_bloc.dart';
import 'package:bloc_auth/repositories/auth_repository.dart';
import 'package:bloc_auth/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent -- bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition -- bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('onError -- bloc: ${bloc.runtimeType}, error: $error');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  final AuthRepository authRepository = AuthRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(authRepository: authRepository)..add(AppStarted()),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
              authRepository: authRepository,
              authBloc: BlocProvider.of<AuthBloc>(context)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        AppRouter.router.refresh();
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
