import 'package:ctrl/ctrl.dart';
import 'package:frontend/data/user_model.dart';
import 'package:frontend/data/user_repository.dart';
import 'package:frontend/shared/result.dart';

class UserState {
  List<User> users = [];
  String error = '';
  bool hasError = false;
  bool firstLoad = true;
}

class UserCtrl with Ctrl {
  UserCtrl({required UserRepository userRepository})
    : _userRepository = userRepository;

  final UserRepository _userRepository;

  late final users = mutable<UserState>(UserState());

  Future<void> getUsers() async {
    executeAsync(() async {
      final listUsers = await _userRepository.getAllUsers();
      users.update((state) {
        state.firstLoad = false;
        switch (listUsers) {
          case Ok():
            state.users = listUsers.value;
            state.hasError = false;
            break;
          case Err():
            state.error = listUsers.error;
            state.hasError = true;
            break;
        }
      });
    });
  }
}
