import 'package:bloc_auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:bloc_auth/bloc/auth_bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Row(
          children: [
            ElevatedButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(LoggedOut());
                },
                child: const Text("logout")),
            const SizedBox(
              width: 12,
            ),
            ElevatedButton(
                onPressed: () => context.push('/another'),
                child: const Text("navigate to another screen")),
          ],
        ));
  }
}
