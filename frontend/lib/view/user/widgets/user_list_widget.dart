import 'package:flutter/material.dart';
import 'package:frontend/data/user_model.dart';
import 'package:frontend/view/user/widgets/user_card_wiget.dart';
import 'package:shimmer/shimmer.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final bool isLoading;
  final void Function(User)? onUserTap;

  const UserList({
    super.key,
    required this.users,
    this.isLoading = false,
    this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: IgnorePointer(
              child: UserCard(
                user: User(name: 'Carregando Nome', email: 'carregando...'),
              ),
            ),
          );
        },
      );
    }

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
