import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/custom_app_bar.dart';
import 'package:frontend/view/user/create/user_create_form.dart';
import 'package:frontend/view/user/list/user_controller.dart';
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

  // For this take-home, it's fine to keep this here. But in a real app,
  //I would extract this to a separate widget.
  void showCreateBottonSheet(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    if (isWideScreen) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: UserForm(
              onUserCreated: () {
                Navigator.pop(context);
                ctrl.getUsers();
              },
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
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
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return _UsersViewDesktop(
            ctrl:
                ctrl, // I prefer constructor injection for shallow widget trees
            onAddUser: () => showCreateBottonSheet(context),
          );
        } else {
          return _UsersViewMobile(
            ctrl: ctrl,
            onAddUser: () => showCreateBottonSheet(context),
          );
        }
      },
    );
  }
}

// If the app grows, we can extract these widgets to separate part files to better organize the code.
// But again, for this take-home, it's fine to keep them here in my opinion.

class _UsersBody extends StatelessWidget {
  const _UsersBody({required this.ctrl});

  final UserCtrl ctrl;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => ctrl.getUsers(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
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
      ),
    );
  }
}

class _UsersViewMobile extends StatelessWidget {
  const _UsersViewMobile({required this.ctrl, required this.onAddUser});

  final UserCtrl ctrl;
  final VoidCallback onAddUser;

  @override
  Widget build(BuildContext context) {
    final narrowScreenActions = [
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
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => ctrl.getUsers(),
                );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.mobile(title: _title, actions: narrowScreenActions),
      body: _UsersBody(ctrl: ctrl),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _UsersViewDesktop extends StatelessWidget {
  const _UsersViewDesktop({required this.ctrl, required this.onAddUser});

  final UserCtrl ctrl;
  final VoidCallback onAddUser;

  @override
  Widget build(BuildContext context) {
    final wideScreenActions = [
      Watch(
        ctrl.isLoading,
        builder: (context, isLoading) {
          return isLoading && !ctrl.users.value.firstLoad
              ? const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => ctrl.getUsers(),
                );
        },
      ),
      TextButton.icon(
        onPressed: onAddUser,
        icon: const Icon(Icons.add),
        label: const Text('NOVO USUÁRIO'),
        style: TextButton.styleFrom(foregroundColor: Colors.black87),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.largeScreen(
        title: _title,
        actions: wideScreenActions,
      ),
      body: _UsersBody(ctrl: ctrl),
    );
  }
}
