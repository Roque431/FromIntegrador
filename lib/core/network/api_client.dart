import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  late final String baseUrl;
  final http.Client _httpClient;
  String? _authToken;

  ApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client() {
    baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  }

  // Setter para el token de autenticación
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Getter para verificar si hay token
  bool get hasToken => _authToken != null && _authToken!.isNotEmpty;

  // Headers por defecto
  Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Headers con autenticación
  Map<String, String> get _authHeaders => {
        ..._defaultHeaders,
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // GET Request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters,
      );

      final response = await _httpClient.get(
        uri,
        headers: requiresAuth ? _authHeaders : _defaultHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Error en GET request: $e');
    }
  }

  // POST Request
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await _httpClient.post(
        uri,
        headers: requiresAuth ? _authHeaders : _defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Error en POST request: $e');
    }
  }

  // PUT Request
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await _httpClient.put(
        uri,
        headers: requiresAuth ? _authHeaders : _defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Error en PUT request: $e');
    }
  }

  // DELETE Request
  Future<dynamic> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await _httpClient.delete(
        uri,
        headers: requiresAuth ? _authHeaders : _defaultHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Error en DELETE request: $e');
    }
  }

  // Manejo de respuestas
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return null;
        return jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        throw BadRequestException(
          _getErrorMessage(response),
        );
      case 401:
        throw UnauthorizedException(
          _getErrorMessage(response),
        );
      case 403:
        throw ForbiddenException(
          _getErrorMessage(response),
        );
      case 404:
        throw NotFoundException(
          _getErrorMessage(response),
        );
      case 500:
        throw ServerException(
          _getErrorMessage(response),
        );
      default:
        throw ApiException(
          'Error desconocido: ${response.statusCode}',
        );
    }
  }

  String _getErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? body['error'] ?? 'Error desconocido';
    } catch (e) {
      return 'Error en la respuesta del servidor';
    }
  }

  void dispose() {
    _httpClient.close();
  }
}

// Excepciones personalizadas
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message);
}

class ServerException extends ApiException {
  ServerException(super.message);
}
