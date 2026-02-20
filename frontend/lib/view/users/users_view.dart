import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UsersRoute extends GoRoute {
  UsersRoute()
    : super(path: '/', builder: (context, state) => const UsersView());
}

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Usuários')));
  }
}
