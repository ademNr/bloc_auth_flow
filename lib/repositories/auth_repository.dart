import 'package:bloc_auth/core/config/api.dart';
import 'package:bloc_auth/core/config/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return true;
    },
  ));
  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  Future<void> persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<Response> login(String email, String password) async {
    try {
      Response response = await dio.post(Api.apiUrl + EndPoints.loginEndPoint,
          data: {'email': email, 'password': password});

      return response;
    } catch (error) {
      rethrow;
    }
  }
}
