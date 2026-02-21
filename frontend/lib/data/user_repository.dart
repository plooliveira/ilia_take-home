import 'package:frontend/data/api/http_client.dart';
import 'package:frontend/data/pagination_model.dart';
import 'package:frontend/data/user_model.dart';
import 'package:frontend/shared/result.dart';

class UserRepository {
  final ApiClient apiClient;

  UserRepository({required this.apiClient});

  Future<Result<PaginatedUsers>> getAllUsers({int page = 1}) async {
    try {
      final response = await apiClient.get('users?page=$page');
      final paginatedUsers = PaginatedUsers.fromJson(response);
      return Ok(paginatedUsers);
    } on NetworkException catch (e) {
      return Err(e.message);
    } catch (e) {
      return Err('Erro inesperado ao buscar usuários: $e');
    }
  }

  Future<Result<User>> createUser({
    required String name,
    required String email,
  }) async {
    try {
      final response =
          await apiClient.post('users', {'name': name, 'email': email});
      final user = User.fromJson(response);
      return Ok(user);
    } on NetworkException catch (e) {
      if (e.listMessages.isNotEmpty) {
        return Err(e.listMessages.join('\n'));
      }
      return Err(e.message);
    } catch (e) {
      return Err('Erro inesperado ao criar usuário: $e');
    }
  }
}
