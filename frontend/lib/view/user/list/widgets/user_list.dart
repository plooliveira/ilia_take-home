import 'package:flutter/material.dart';
import 'package:frontend/data/user_model.dart';
import 'package:frontend/view/user/list/widgets/user_card.dart';
import 'package:shimmer/shimmer.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMorePages;
  final void Function(User)? onUserTap;
  final VoidCallback? onLoadMore;
  final ScrollController? scrollController;

  const UserList({
    super.key,
    required this.users,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMorePages = false,
    this.onUserTap,
    this.onLoadMore,
    this.scrollController,
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

    final itemCount = users.length + (hasMorePages ? 1 : 0);
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == users.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final user = users[index];
        return UserCard(
          user: user,
          onTap: onUserTap != null ? () => onUserTap!(user) : null,
        );
      },
    );
  }
}
