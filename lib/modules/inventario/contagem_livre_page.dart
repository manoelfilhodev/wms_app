import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../layout/main_layout.dart';

class ContagemLivrePage extends StatefulWidget {
  const ContagemLivrePage({super.key});

  @override
  State<ContagemLivrePage> createState() => _ContagemLivrePageState();
}

class _ContagemLivrePageState extends State<ContagemLivrePage> {
  final TextEditingController posicaoController = TextEditingController();
  final TextEditingController eanController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();

  final FocusNode posicaoFocus = FocusNode();
  final FocusNode eanFocus = FocusNode();
  final FocusNode quantidadeFocus = FocusNode();

  String infoProduto = "";
  String? sku;
  bool carregando = false;
  int? usuarioId;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usuarioId = prefs.getInt('usuario_id');
    });
  }

  Future<void> buscarDescricao(String ean) async {
    if (ean.isEmpty) return;
    try {
      final uri = Uri.parse(
          "https://systex.com.br/wms/public/api/contagem-livre/buscarDescricaoApi?ean=$ean");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final produto = data['data'];
          setState(() {
            sku = produto['sku'];
            final descricao = produto['descricao'] ?? '';
            infoProduto = "$sku - $descricao";
          });
        } else {
          _resetProduto("Produto não encontrado");
        }
      } else {
        _resetProduto("Erro ao buscar produto");
      }
    } catch (e) {
      _resetProduto("Erro de conexão");
    }
  }

  Future<void> salvarContagem() async {
    final posicao = posicaoController.text.trim();
    final ean = eanController.text.trim();
    final quantidade = quantidadeController.text.trim();

    if (posicao.isEmpty || ean.isEmpty || quantidade.isEmpty) {
      _showDialog(DialogType.warning, "Atenção", "Preencha todos os campos.");
      return;
    }

    final qtd = int.tryParse(quantidade) ?? 0;
    if (qtd <= 0) {
      _showDialog(DialogType.warning, "Atenção", "Quantidade inválida.");
      return;
    }

    if (usuarioId == null) {
      _showDialog(DialogType.error, "Erro", "Usuário não identificado.");
      return;
    }

    if (sku == null) {
      _showDialog(DialogType.error, "Erro", "Produto não identificado pelo EAN.");
      return;
    }

    setState(() => carregando = true);

    try {
      final uri = Uri.parse(
          "https://systex.com.br/wms/public/api/contagem-livre/store");
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "contado_por": usuarioId,
          "sku": sku,
          "ficha": posicao,
          "quantidade": qtd,
          "data_hora": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _showDialog(
          DialogType.success,
          "Sucesso",
          data['message'] ?? "Contagem registrada com sucesso!",
        );
        _resetCampos();
      } else {
        _showDialog(DialogType.error, "Erro", "Erro: ${response.body}");
      }
    } catch (e) {
      _showDialog(DialogType.error, "Erro", "Erro de conexão: $e");
    }

    setState(() => carregando = false);
  }

  void _resetProduto(String mensagem) {
    setState(() {
      sku = null;
      infoProduto = mensagem;
    });
  }

  void _resetCampos() {
    posicaoController.clear();
    eanController.clear();
    quantidadeController.clear();
    infoProduto = "";
    sku = null;
    FocusScope.of(context).requestFocus(posicaoFocus);
  }

  void _showDialog(DialogType type, String title, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.scale,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  void dispose() {
    posicaoController.dispose();
    eanController.dispose();
    quantidadeController.dispose();
    posicaoFocus.dispose();
    eanFocus.dispose();
    quantidadeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Contagem Livre"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF404954), // COR EXATA DO CARD ♥️
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                offset: const Offset(0, 6),
                blurRadius: 16,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Dados da Contagem",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF9FA8DA),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                // Campo: posição
                TextField(
                  controller: posicaoController,
                  focusNode: posicaoFocus,
                  decoration: const InputDecoration(
                    labelText: "Posição",
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  onSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(eanFocus),
                ),
                const SizedBox(height: 16),

                // Campo: EAN
                TextField(
                  controller: eanController,
                  focusNode: eanFocus,
                  decoration: const InputDecoration(
                    labelText: "EAN",
                    prefixIcon: Icon(Icons.qr_code_2_outlined),
                  ),
                  onSubmitted: (value) async {
                    await buscarDescricao(value);
                    FocusScope.of(context).requestFocus(quantidadeFocus);
                  },
                ),
                const SizedBox(height: 8),

                if (infoProduto.isNotEmpty)
                  Text(
                    infoProduto,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(height: 16),

                // Campo: quantidade
                TextField(
                  controller: quantidadeController,
                  focusNode: quantidadeFocus,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantidade",
                    prefixIcon: Icon(Icons.numbers_rounded),
                  ),
                  onSubmitted: (_) => salvarContagem(),
                ),
                const SizedBox(height: 24),

                carregando
                    ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : ElevatedButton.icon(
                        onPressed: salvarContagem,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text("Salvar Contagem"),
                      ),
                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  label: const Text("Voltar"),
                ),
                const SizedBox(height: 18),

                Center(
                  child: Text(
                    "Powered by Laravel API • Systex Infra Azure",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
