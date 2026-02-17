import 'package:flutter/material.dart';
import 'package:wms_app/core/exceptions/auth_exception.dart';
import 'package:wms_app/core/widgets/systex_glass_card.dart';
import 'package:wms_app/core/widgets/systex_scaffold.dart';
import 'package:wms_app/modules/auth/auth_service.dart';
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
  final AuthService _authService = AuthService();

  bool _loading = false;
  bool _obscurePass = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final data = await _authService.login(
        username: _userController.text.trim(),
        password: _passController.text.trim(),
      );

      final token = data['token']?.toString() ?? '';
      final dynamic userRaw = data['user'];
      final user = userRaw is Map ? Map<String, dynamic>.from(userRaw) : null;

      if (user != null && user.isNotEmpty) {
        await UserService.saveUser(
          token: token,
          id: _toInt(user['id_user'] ?? user['id']),
          nome: user['nome']?.toString() ?? '',
          nivel: user['nivel']?.toString() ?? '',
          tipo: user['tipo']?.toString() ?? '',
          unidade: _toInt(user['unidade']),
        );

        if (!mounted) return;
        Notifier.success(context, "Bem-vindo, ${user['nome'] ?? ''}!");
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        if (!mounted) return;
        Notifier.error(context, 'Resposta inválida do servidor');
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      await _showAuthErrorDialog(e.message);
    } catch (e) {
      if (!mounted) return;
      Notifier.warning(context, 'Erro de conexão: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _showAuthErrorDialog(String message) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Erro de autenticação'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;

    return SystexScaffold(
      useSafeArea: false,
      padding: EdgeInsets.zero,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 400,
            child: SystexGlassCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warehouse_rounded,
                      size: 56,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Systex',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gestão de Armazéns Inteligente',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const Divider(height: 32),
                    TextFormField(
                      controller: _userController,
                      decoration: const InputDecoration(
                        labelText: 'Usuário',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Informe o usuário' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passController,
                      obscureText: _obscurePass,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePass
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Informe a senha' : null,
                    ),
                    const SizedBox(height: 24),
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
                            : const Text('Entrar no Sistema'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Conexão segura via SSL • Laravel 10 backend',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor?.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Hospedado na Azure Cloud • Infraestrutura Systex',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor?.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '© 2025 Systex Sistemas Inteligentes',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor?.withValues(alpha: 0.6),
                        fontSize: 11,
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
