import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';
import 'package:frontend/view/user/user_controller.dart';
import 'package:go_router/go_router.dart';

const _noUsersFound = "Nenhum usuário encontrado";

class UsersRoute extends GoRoute {
  UsersRoute()
    : super(path: '/', builder: (context, state) => const UsersView());
}

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends CtrlState<UsersView> {
  late final UserController controller;

  @override
  void initState() {
    super.initState();
    controller = useCtrl();
    controller.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      body: GroupWatch(
        [controller.users, controller.isLoading, controller.error],
        builder: (context) {
          final users = controller.users.value;
          final isLoading = controller.isLoading.value;
          final error = controller.error.value;

          if (error.isNotEmpty) {
            return Center(child: Text(error));
          }

          if (users.isEmpty) {
            return const Center(child: Text(_noUsersFound));
          }

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          );
        },
      ),
    );
  }
}
