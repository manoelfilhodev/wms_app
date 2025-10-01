import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/user_service.dart';

class ContagemLivreService {
  static const String baseUrl = "https://seu-dominio.com/api"; // ajuste aqui

  static Future<bool> salvarContagem(List<Map<String, dynamic>> itens) async {
    try {
      final usuarioId = await UserService.getUserId();
      final token = await UserService.getToken();

      if (usuarioId == null) {
        print("Usuário não encontrado.");
        return false;
      }

      final response = await http.post(
        Uri.parse("$baseUrl/contagem-livre"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "usuario_id": usuarioId,
          // se quiser depois pode salvar também unidade/empresa aqui
          "itens": itens,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Erro API: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exceção: $e");
      return false;
    }
  }
}
