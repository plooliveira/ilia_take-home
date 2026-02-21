import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/user_model.dart';
import 'package:frontend/data/user_repository.dart';
import 'package:frontend/shared/result.dart';

class UserState {
  List<User> users = [];
  String error = '';
  bool hasError = false;
  bool firstLoad = true;
  int currentPage = 1;
  bool hasMorePages = true;
  bool isLoadingMore = false;
}

class UserCtrl with Ctrl {
  UserCtrl({required UserRepository userRepository})
    : _userRepository = userRepository;

  final UserRepository _userRepository;

  late final users = mutable<UserState>(UserState());

  final scrollController = ScrollController();

  Future<void> getUsers() async {
    // This is for initial load or pull-to-refresh
    await executeAsync(() async {
      users.update((state) {
        state.hasError = false;
        state.currentPage = 1;
        state.hasMorePages = true;
      });

      final result = await _userRepository.getAllUsers(page: 1);

      users.update((state) {
        state.firstLoad = false;
        switch (result) {
          case Ok(value: final paginatedData):
            state.users = paginatedData.data;
            state.currentPage++;
            state.hasMorePages =
                state.currentPage <= paginatedData.meta.lastPage;
            break;
          case Err(error: final error):
            state.users = [];
            state.error = error;
            state.hasError = true;
            break;
        }
      });
    });
  }

  Future<void> loadMoreUsers() async {
    if ((isLoading.value ||
        users.value.isLoadingMore ||
        !users.value.hasMorePages)) {
      return;
    }

    users.update((state) => state.isLoadingMore = true);

    final result = await _userRepository.getAllUsers(
      page: users.value.currentPage,
    );

    users.update((state) {
      switch (result) {
        case Ok(value: final paginatedData):
          state.users.addAll(paginatedData.data);
          state.currentPage++;
          state.hasMorePages = state.currentPage <= paginatedData.meta.lastPage;
          break;
        case Err(error: final error):
          state.error = error;
          state.hasError = true;
          break;
      }
      state.isLoadingMore = false;
    });
  }

  void refreshUsers() async {
    await getUsers();
    _scrollToTop();
  }

  void _scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
