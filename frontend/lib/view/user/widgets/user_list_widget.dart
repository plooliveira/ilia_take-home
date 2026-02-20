import 'package:flutter/material.dart';
import 'package:frontend/data/user_model.dart';
import 'package:frontend/view/user/widgets/user_card_wiget.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final void Function(User)? onUserTap;

  const UserList({super.key, required this.users, this.onUserTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          user: user,
          onTap: onUserTap != null ? () => onUserTap!(user) : null,
        );
      },
    );
  }
}
