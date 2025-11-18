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
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _loading = false;
  bool _obscurePass = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final dio = Dio();
      final response = await dio.post(
        "https://systex.com.br/wms/public/api/login",
        data: {
          "username": _userController.text.trim(),
          "password": _passController.text.trim(),
        },
        options: Options(
          headers: {'Accept': 'application/json'},
          validateStatus: (_) => true,
        ),
      );

      final data = response.data;

      if (response.statusCode == 200 && data != null && data['user'] != null) {
        final user = data['user'];

        await UserService.saveUser(
                token: data['token'] ?? '',
                id: user['id'] ?? 0,
                nome: user['nome'] ?? '',
                nivel: user['nivel'] ?? '',
                tipo: user['tipo'] ?? '',
                unidade: user['unidade'] ?? 0,
              );


        if (!mounted) return;
        Notifier.success(context, "Bem-vindo, ${user['nome']}!");
        Navigator.pushReplacementNamed(context, "/dashboard");
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
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 400,
            child: Card(
              elevation: theme.cardTheme.elevation,
              shape: theme.cardTheme.shape,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warehouse_rounded,
                        size: 56,
                        color: Color(0xFF727CF5),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        "Systex",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Gestão de Armazéns Inteligente",
                        style: theme.textTheme.bodyMedium,
                      ),

                      const Divider(height: 32),

                      // Usuário
                      TextFormField(
                        controller: _userController,
                        decoration: const InputDecoration(
                          labelText: "Usuário",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Informe o usuário" : null,
                      ),
                      const SizedBox(height: 16),

                      // Senha
                      TextFormField(
                        controller: _passController,
                        obscureText: _obscurePass,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePass
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() => _obscurePass = !_obscurePass);
                            },
                          ),
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
                          child: _loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Entrar no Sistema"),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Column(
                        children: [
                          const Divider(height: 32),
                          Text(
                            "Conexão segura via SSL • Laravel 10 backend",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Hospedado na Azure Cloud • Infraestrutura Systex",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "© 2025 Systex Sistemas Inteligentes",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: textColor?.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
