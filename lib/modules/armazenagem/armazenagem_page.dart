import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../layout/main_layout.dart';

class ArmazenagemPage extends StatefulWidget {
  const ArmazenagemPage({super.key});

  @override
  State<ArmazenagemPage> createState() => _ArmazenagemPageState();
}

class _ArmazenagemPageState extends State<ArmazenagemPage> {
  final TextEditingController posicaoController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();

  final FocusNode posicaoFocus = FocusNode();
  final FocusNode skuFocus = FocusNode();
  final FocusNode quantidadeFocus = FocusNode();

  String descricaoProduto = "";
  String skuBanco = "";
  String posicaoMessage = "";
  bool carregando = false;

  int? usuarioId; // agora dinâmico

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

  // 🔎 Valida posição no banco
  Future<void> validarPosicao(String posicao) async {
    try {
      final url = Uri.parse(
          "https://systex.com.br/wms/public/api/armazenagem/buscarPosicoes?term=$posicao");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.contains(posicao)) {
          setState(() {
            posicaoMessage = "✅ Posição válida";
          });
          FocusScope.of(context).requestFocus(skuFocus);
          return;
        }
      }
      setState(() {
        posicaoMessage = "❌ Posição não encontrada";
      });
    } catch (e) {
      setState(() {
        posicaoMessage = "⚠️ Erro de conexão";
      });
    }
  }

  Future<void> buscarDescricao(String sku) async {
    try {
      final url = Uri.parse(
          "https://systex.com.br/wms/public/api/armazenagem/buscarDescricaoApi?sku=$sku");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          descricaoProduto = data['descricao'] ?? '';
          skuBanco = data['sku']?.toString() ?? sku;
        });
      } else {
        setState(() {
          descricaoProduto = "Produto não encontrado";
          skuBanco = "";
        });
      }
    } catch (e) {
      setState(() {
        descricaoProduto = "Erro de conexão";
        skuBanco = "";
      });
    }
  }

  Future<void> armazenarProduto() async {
    final posicao = posicaoController.text.trim();
    final sku = skuController.text.trim();
    final quantidade = quantidadeController.text.trim();

    if (posicao.isEmpty || sku.isEmpty || quantidade.isEmpty) {
      _showDialog(DialogType.warning, "Atenção", "Preencha todos os campos.");
      return;
    }

    final qtd = int.tryParse(quantidade) ?? 0;
    if (qtd <= 0 || qtd > 1000) {
      _showDialog(DialogType.warning, "Atenção",
          "Quantidade inválida. Máximo permitido: 1000 peças.");
      return;
    }

    if (usuarioId == null) {
      _showDialog(DialogType.error, "Erro", "Usuário não identificado.");
      return;
    }

    setState(() => carregando = true);

    try {
      final url = Uri.parse(
          "https://systex.com.br/wms/public/api/armazenagem/store-api");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "sku": sku,
          "quantidade": qtd,
          "endereco": posicao,
          "observacoes": "armazenagem via coletor",
          "usuario_id": usuarioId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _showDialog(DialogType.success, "Sucesso",
            data['message'] ?? "Produto armazenado com sucesso!");

        posicaoController.clear();
        skuController.clear();
        quantidadeController.clear();
        descricaoProduto = "";
        skuBanco = "";
        posicaoMessage = "";

        FocusScope.of(context).requestFocus(posicaoFocus);
      } else {
        _showDialog(DialogType.error, "Erro", "Erro: ${response.body}");
      }
    } catch (e) {
      _showDialog(DialogType.error, "Erro", "Erro de conexão: $e");
    }

    setState(() => carregando = false);
  }

  // 🎨 Caixa de diálogo estilo SweetAlert
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
    skuController.dispose();
    quantidadeController.dispose();
    posicaoFocus.dispose();
    skuFocus.dispose();
    quantidadeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Armazenagem",
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
              onSubmitted: (value) async => await validarPosicao(value),
            ),
            if (posicaoMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  posicaoMessage,
                  style: TextStyle(
                    color: posicaoMessage.contains("✅")
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Campo SKU/EAN
            TextField(
              controller: skuController,
              focusNode: skuFocus,
              decoration: const InputDecoration(
                labelText: "SKU / EAN",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) async {
                await buscarDescricao(value);
                FocusScope.of(context).requestFocus(quantidadeFocus);
              },
            ),
            const SizedBox(height: 8),
            if (descricaoProduto.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Descrição: $descricaoProduto",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("SKU Banco: $skuBanco",
                      style: const TextStyle(fontSize: 14)),
                ],
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
              onSubmitted: (_) => armazenarProduto(),
            ),
            const SizedBox(height: 24),

            carregando
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: armazenarProduto,
                    icon: const Icon(Icons.save),
                    label: const Text("Salvar"),
                  ),
          ],
        ),
      ),
    );
  }
}

