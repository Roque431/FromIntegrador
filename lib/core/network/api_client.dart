import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  late final String baseUrl;
  final http.Client _httpClient;
  String? _authToken;

  ApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client() {
    // Detectar automáticamente la URL según la plataforma
    if (kIsWeb) {
      // En web, usar localhost
      baseUrl = dotenv.env['API_URL_WEB'] ?? 'http://localhost:80';
    } else {
      // En móvil (Android/iOS), usar la IP de la laptop
      baseUrl = dotenv.env['API_URL_MOBILE'] ?? dotenv.env['API_URL'] ?? 'http://172.20.10.2:80';
    }
    print('🌐 ApiClient inicializado con baseUrl: $baseUrl (isWeb: $kIsWeb)');
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

      // Logging for debugging
      print('🚀 GET: $uri');

      final response = await _httpClient.get(
        uri,
        headers: requiresAuth ? _authHeaders : _defaultHeaders,
      );

      print('📥 Response ${response.statusCode}: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Error en GET request: $e');
    }
  }

  // POST Request
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters,
      );

      // Temporary logging for debugging
      print('🚀 POST: $uri');
      if (body != null) {
        print('📤 Body: ${jsonEncode(body)}');
      }

      final response = await _httpClient.post(
        uri,
        headers: requiresAuth ? _authHeaders : _defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      print('📥 Response ${response.statusCode}: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ POST Error: $e');
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

      // Logging for debugging
      print('🚀 PUT: $uri');
      if (body != null) print('📤 Body: ${jsonEncode(body)}');

      final response = await _httpClient.put(
        uri,
        headers: requiresAuth ? _authHeaders : _defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      print('📥 Response ${response.statusCode}: ${response.body}');

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
        try {
          return jsonDecode(response.body);
        } catch (e) {
          // Si no se puede parsear como JSON, devolver el body como string
          print('⚠️ Response no es JSON válido: ${response.body}');
          return response.body;
        }
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
        final errorDetail = _getErrorDetail(response);
        throw ForbiddenException(
          _getErrorMessage(response),
          detail: errorDetail,
        );
      case 404:
        throw NotFoundException(
          _getErrorMessage(response),
        );
      case 422:
        // FastAPI validation error
        throw BadRequestException(
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
      // Si detail es un objeto (como en límite de consultas)
      if (body['detail'] is Map) {
        final detail = body['detail'] as Map<String, dynamic>;
        return detail['message'] ?? detail['error'] ?? 'Error desconocido';
      }
      // FastAPI 422 típicamente devuelve una lista en 'detail'
      if (body['detail'] is List) {
        final List details = body['detail'];
        if (details.isNotEmpty && details.first is Map) {
          final Map first = details.first as Map;
          final msg = first['msg'] ?? first['message'] ?? 'Error de validación';
          final loc = (first['loc'] is List) ? (first['loc'] as List).join('.') : first['loc'];
          return loc != null ? '$msg (campo: $loc)' : '$msg';
        }
        return 'Error de validación';
      }
      return body['detail'] ?? body['message'] ?? body['error'] ?? 'Error desconocido';
    } catch (e) {
      return 'Error en la respuesta del servidor';
    }
  }
  
  Map<String, dynamic>? _getErrorDetail(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body['detail'] is Map) {
        return body['detail'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
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
  final Map<String, dynamic>? detail;
  ForbiddenException(super.message, {this.detail});
  
  bool get isQuotaLimit => detail != null && detail!['error'] == 'Límite de consultas alcanzado';
  int? get usage => detail?['usage'];
  int? get limit => detail?['limit'];
  String? get resetDate => detail?['reset_date'];
}

class NotFoundException extends ApiException {
  NotFoundException(super.message);
}

class ServerException extends ApiException {
  ServerException(super.message);
}
