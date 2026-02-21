import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/user_repository.dart';
import 'package:frontend/shared/result.dart';

class UserFormCtrl with Ctrl {
  UserFormCtrl({required this.userRepository});

  final UserRepository userRepository;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  VoidCallback? onUserCreated;
  void Function(String)? onUserCreationError;

  void createUser() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    executeAsync(() async {
      var response = await userRepository.createUser(
        name: nameController.text,
        email: emailController.text,
      );

      switch (response) {
        case Ok():
          onUserCreated?.call();
          break;
        case Err():
          onUserCreationError?.call(response.error);
          break;
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
