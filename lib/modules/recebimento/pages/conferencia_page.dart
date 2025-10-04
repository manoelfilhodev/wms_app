import 'package:flutter/material.dart';

class ConferenciaPage extends StatefulWidget {
  const ConferenciaPage({super.key});

  @override
  State<ConferenciaPage> createState() => _ConferenciaPageState();
}

class _ConferenciaPageState extends State<ConferenciaPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _skuController = TextEditingController();
  final _qtdController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _skuController.dispose();
    _qtdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Conferência de Recebimento"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: theme.cardTheme.elevation,
          shape: theme.cardTheme.shape,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Dados da Conferência",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: "Recebimento ID / Nota Fiscal",
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Informe o número do recebimento" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _skuController,
                    decoration: const InputDecoration(
                      labelText: "SKU / EAN",
                      prefixIcon: Icon(Icons.qr_code_2_outlined),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Informe o código do produto" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _qtdController,
                    decoration: const InputDecoration(
                      labelText: "Quantidade",
                      prefixIcon: Icon(Icons.format_list_numbered),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v!.isEmpty ? "Informe a quantidade" : null,
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: integrar service real
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Item salvo com sucesso ✅"),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: const Text("Salvar Conferência"),
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_outlined),
                    label: const Text("Voltar"),
                  ),
                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      "Powered by Laravel API • Systex Infra Azure",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
