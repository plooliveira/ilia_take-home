import 'package:frontend/data/user_model.dart';

class PaginatedUsers {
  final List<User> data;
  final PaginationMeta meta;

  PaginatedUsers({required this.data, required this.meta});

  factory PaginatedUsers.fromJson(Map<String, dynamic> json) {
    return PaginatedUsers(
      data: (json['data'] as List).map((i) => User.fromJson(i)).toList(),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }
}

class PaginationMeta {
  final int total;
  final int page;
  final int lastPage;

  PaginationMeta({
    required this.total,
    required this.page,
    required this.lastPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: json['total'] as int,
      page: json['page'] as int,
      lastPage: json['lastPage'] as int,
    );
  }
}
