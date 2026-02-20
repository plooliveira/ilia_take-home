import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';
import 'package:frontend/view/user/list/user_controller.dart';
import 'package:frontend/view/user/create/user_create_form.dart';
import 'package:frontend/view/user/list/widgets/user_list.dart';
import 'package:frontend/view/user/list/widgets/users_empty.dart';
import 'package:frontend/view/user/list/widgets/users_error.dart';
import 'package:go_router/go_router.dart';

const _noUsersFound = "Nenhum usuário encontrado";
const _title = "Usuários";

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
  late final UserCtrl ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = useCtrl();
    ctrl.getUsers();
  }

  void showCreateBottonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return UserForm(
          onUserCreated: () {
            Navigator.pop(context);
            ctrl.getUsers();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          _title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          Watch(
            ctrl.isLoading,
            builder: (context, isLoading) {
              return isLoading && !ctrl.users.value.firstLoad
                  ? const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ctrl.getUsers(),
        child: GroupWatch(
          [ctrl.users],
          builder: (context) {
            final state = ctrl.users.value;

            if (state.hasError) {
              return UsersErrorWidget(
                error: state.error,
                onRetry: () => ctrl.getUsers(),
              );
            }

            if (state.users.isEmpty && !state.firstLoad) {
              return const UsersEmptyWidget(message: _noUsersFound);
            }

            return UserList(
              users: state.users,
              isLoading: ctrl.isLoading.value && state.firstLoad,
              onUserTap: (user) {
                // Future navigation to user details or whatever...
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateBottonSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
