import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';
import 'package:frontend/view/user/user_controller.dart';
import 'package:frontend/view/user/widgets/user_card_wiget.dart';
import 'package:frontend/view/user/widgets/user_list_widget.dart';
import 'package:frontend/view/user/widgets/users_empty_widget.dart';
import 'package:frontend/view/user/widgets/users_error_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Usuários',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          Watch(
            controller.isLoading,
            builder: (context, isLoading) {
              return isLoading && !controller.users.value.firstLoad
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
        onRefresh: () => controller.getUsers(),
        child: GroupWatch(
          [controller.users],
          builder: (context) {
            final state = controller.users.value;

            if (state.hasError) {
              return UsersErrorWidget(
                error: state.error,
                onRetry: () => controller.getUsers(),
              );
            }

            if (state.users.isEmpty && !state.firstLoad) {
              return const UsersEmptyWidget(message: _noUsersFound);
            }

            return UserList(
              users: state.users,
              isLoading: controller.isLoading.value && state.firstLoad,
              onUserTap: (user) {
                // Future navigation to user details or whatever...
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // bottom sheet to create user
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return const UserCreateForm();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserCreateForm extends CtrlWidget<UserController> {
  const UserCreateForm({super.key});

  @override
  Widget build(BuildContext context, controller) {
    return const Placeholder();
  }
}
