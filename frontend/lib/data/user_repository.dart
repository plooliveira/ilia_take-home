import 'package:frontend/data/api/http_client.dart';
import 'package:frontend/data/user_model.dart';
import 'package:frontend/shared/result.dart';

class UserRepository {
  final ApiClient apiClient;

  UserRepository({required this.apiClient});

  Future<Result<List<User>>> getAllUsers() async {
    try {
      final response = await apiClient.get('users');
      final List<dynamic> data = response as List<dynamic>;
      final users = data.map((json) => User.fromJson(json)).toList();
      return Ok(users);
    } on NetworkException catch (e) {
      return Err(e.message);
    } catch (e) {
      return Err('Erro inesperado ao buscar usuários: $e');
    }
  }

  Future<Result<bool>> createUser(Map<String, String> userData) async {
    try {
      await apiClient.post('users', userData);
      return Ok(true);
    } on NetworkException catch (e) {
      return Err(e.message);
    } catch (e) {
      return Err('Erro inesperado ao criar usuário: $e');
    }
  }
}
