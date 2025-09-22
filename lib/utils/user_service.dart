import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<void> saveUser({
    required String token,
    required int id,
    required String nome,
    required String nivel,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('usuario_id', id);
    await prefs.setString('nome', nome);
    await prefs.setString('nivel', nivel);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuario_id');
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nome');
  }

  static Future<String?> getUserNivel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nivel');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
