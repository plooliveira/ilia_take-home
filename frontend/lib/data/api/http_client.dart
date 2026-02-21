import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:frontend/data/api/config/api_config.dart';
import 'package:http/http.dart' as http;

const _timeoutMessage = 'Tempo de resposta excedido (TimeoutException)';
const _noConnectionMessage = 'Sem conexão com a internet (SocketException)';

class NetworkException implements Exception {
  final String message;
  final List<String> listMessages;
  final int statusCode;
  NetworkException(this.message, this.statusCode, this.listMessages);
}

abstract class ApiClient {
  ApiClient(this.config);
  final ApiConfig config;

  Future<dynamic> get(String url);
  Future<dynamic> post(String url, Map<String, dynamic> data);
}

class HttpApiClient implements ApiClient {
  /// [debug] if true, adds a delay of 1 second to each request.
  HttpApiClient(this.config, {bool debug = false}) : _debug = debug;

  @override
  final ApiConfig config;
  final bool _debug;

  static const _timeoutDuration = Duration(seconds: 10);

  @override
  Future<dynamic> get(String url) async {
    if (_debug) await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await http
          .get(Uri.parse(config.baseUrl + url))
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(_noConnectionMessage, 0, []);
    } on TimeoutException {
      throw NetworkException(_timeoutMessage, 408, []);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> post(String url, Map<String, dynamic> data) async {
    if (_debug) await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await http
          .post(
            Uri.parse(config.baseUrl + url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(_noConnectionMessage, 0, []);
    } on TimeoutException {
      throw NetworkException(_timeoutMessage, 408, []);
    } catch (e) {
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      if (response.body.isEmpty) {
        throw NetworkException('Erro desconhecido', response.statusCode, []);
      }

      final body = jsonDecode(response.body);
      final messageValue = body['message'];

      String message;
      List<String> listMessages = [];

      if (messageValue is String) {
        message = messageValue;
      } else if (messageValue is List) {
        listMessages = messageValue.cast<String>().toList();
        message = 'Invalid input';
      } else {
        message = body['error'] ?? 'Erro desconhecido';
      }

      throw NetworkException(message, response.statusCode, listMessages);
    }
  }
}
