import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<void> saveUser({
    required String token,
    required int id,
    required String nome,
    required String nivel,
    required String tipo,
    required int unidade,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
    await prefs.setInt('usuario_id', id);
    await prefs.setString('nome', nome);
    await prefs.setString('nivel', nivel);

    // Novos campos
    await prefs.setString('tipo', tipo);
    await prefs.setInt('unidade', unidade);
  }

  // ===============================
  // GETTERS
  // ===============================

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

  static Future<String?> getUserTipo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tipo');
  }

  static Future<int?> getUserUnidade() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('unidade');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ===============================
  // LOGOUT
  // ===============================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
