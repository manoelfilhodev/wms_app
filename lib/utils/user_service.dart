import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  /// Salva os dados do usuário logado
  static Future<void> saveUser({
    required String token,
    required int id,
    required String nome,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('user_id', id);
    await prefs.setString('user_nome', nome);
  }

  /// Recupera o token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Recupera o ID do usuário
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  /// Recupera o nome do usuário
  static Future<String?> getUserNome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_nome');
  }

  /// Remove todos os dados (logout)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_id');
    await prefs.remove('user_nome');
  }
}
