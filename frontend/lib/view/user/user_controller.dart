import 'package:ctrl/ctrl.dart';
import 'package:frontend/data/user_model.dart';
import 'package:frontend/data/user_repository.dart';
import 'package:frontend/shared/result.dart';

class UserController with Ctrl {
  UserController({required UserRepository userRepository})
    : _userRepository = userRepository;

  final UserRepository _userRepository;

  late final users = mutable<List<User>>([]);
  late final error = mutable<String>('');

  Future<void> getUsers() async {
    executeAsync(() async {
      error.value = '';
      final listUsers = await _userRepository.getAllUsers();
      switch (listUsers) {
        case Ok():
          users.value = listUsers.value;
          break;
        case Err():
          error.value = listUsers.error;
          break;
      }
    });
  }
}
