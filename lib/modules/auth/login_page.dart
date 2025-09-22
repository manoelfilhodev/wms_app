import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:wms_app/utils/notifier.dart';
import 'package:wms_app/utils/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final response = await Dio().post(
        "https://systex.com.br/wms/public/api/login", // 🔗 ajuste conforme sua API real
        data: {
          "email": _userController.text.trim(),   // troque para "login" se for matrícula
          "password": _passController.text.trim(), // troque para "senha" se sua API usar esse nome
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final token = data['token'] ?? '';
        final user = data['user'] ?? {};

        if (user.isNotEmpty) {
          // Salva dados do usuário no SharedPreferences
          await UserService.saveUser(
            token: token,
            id: user['id_user'] ?? user['id'] ?? 0,
            nome: user['nome'] ?? '',
            nivel: user['nivel'] ?? '',
          );

          if (!mounted) return;
          Notifier.success(context, "Bem-vindo, ${user['nome'] ?? ''}!");

          Navigator.pushReplacementNamed(context, "/dashboard");
        } else {
          Notifier.error(context, "Resposta inválida do servidor");
        }
      } else {
        Notifier.error(context, "Usuário ou senha inválidos");
      }
    } catch (e) {
      Notifier.warning(context, "Erro de conexão: $e");
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "WMS - SYSTEX",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Informe suas credenciais para acessar o painel.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Usuário
                    TextFormField(
                      controller: _userController,
                      decoration: const InputDecoration(
                        labelText: "Usuário",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Informe o usuário" : null,
                    ),
                    const SizedBox(height: 16),

                    // Senha
                    TextFormField(
                      controller: _passController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Senha",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Informe a senha" : null,
                    ),
                    const SizedBox(height: 24),

                    // Botão login
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue,
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : const Text("Login"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
