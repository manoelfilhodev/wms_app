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

  String infoProduto = ""; // Exibe SKU - Descrição
  String? sku;             // Guarda o SKU para salvar
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

  /// 🔎 Busca SKU + descrição pelo EAN
  Future<void> buscarDescricao(String ean) async {
    if (ean.isEmpty) return;

    try {
      final url = Uri.parse(
          "https://systex.com.br/wms/public/api/contagem-livre/buscarDescricaoApi?ean=$ean");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            sku = data['data']['sku'];
            final descricao = data['data']['descricao'] ?? '';
            infoProduto = "$sku - $descricao";
          });
        } else {
          setState(() {
            sku = null;
            infoProduto = "Produto não encontrado";
          });
        }
      } else {
        setState(() {
          sku = null;
          infoProduto = "Produto não encontrado";
        });
      }
    } catch (e) {
      setState(() {
        sku = null;
        infoProduto = "Erro de conexão";
      });
    }
  }

  /// 💾 Salva contagem no banco
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
      final url = Uri.parse("https://systex.com.br/wms/public/api/contagem-livre/store");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "contado_por": usuarioId,   // 👈 agora vai como contado_por
          "sku": sku,                 // 👈 envia o SKU
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

        posicaoController.clear();
        eanController.clear();
        quantidadeController.clear();
        infoProduto = "";
        sku = null;

        FocusScope.of(context).requestFocus(posicaoFocus);
      } else {
        _showDialog(DialogType.error, "Erro", "Erro: ${response.body}");
      }
    } catch (e) {
      _showDialog(DialogType.error, "Erro", "Erro de conexão: $e");
    }

    setState(() => carregando = false);
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
    return MainLayout(
      title: "Contagem Livre",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo posição
            TextField(
              controller: posicaoController,
              focusNode: posicaoFocus,
              decoration: const InputDecoration(
                labelText: "Posição",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(eanFocus),
            ),
            const SizedBox(height: 16),

            // Campo EAN
            TextField(
              controller: eanController,
              focusNode: eanFocus,
              decoration: const InputDecoration(
                labelText: "EAN",
                border: OutlineInputBorder(),
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
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 16),

            // Campo quantidade
            TextField(
              controller: quantidadeController,
              focusNode: quantidadeFocus,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Quantidade",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => salvarContagem(),
            ),
            const SizedBox(height: 24),

            carregando
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: salvarContagem,
                    icon: const Icon(Icons.save),
                    label: const Text("Salvar Contagem"),
                  ),
            const SizedBox(height: 16),

            // Botão voltar
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Voltar"),
            ),
          ],
        ),
      ),
    );
  }
}
