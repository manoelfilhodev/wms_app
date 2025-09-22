import 'package:flutter/material.dart';
import '../recebimento/recebimento_page.dart';
import '../armazenagem/armazenagem_page.dart';
import '../separacao/separacao_page.dart';
import '../expedicao/expedicao_page.dart';
import '../inventario/inventario_page.dart';
import '../auth/login_page.dart'; // ajuste o caminho conforme sua estrutura real

class DashboardPage extends StatelessWidget {
  final String userName;

  const DashboardPage({super.key, this.userName = "Usuário"});

  String get firstName {
    if (userName.trim().isEmpty) return "Usuário";
    return userName.split(" ").first;
  }

  @override
  Widget build(BuildContext context) {
    final cards = [
      {"title": "📦 Recebimento", "page": const RecebimentoPage()},
      {"title": "🏷️ Armazenagem", "page": const ArmazenagemPage()},
      {"title": "📑 Separação", "page": const SeparacaoPage()},
      {"title": "🚚 Expedição", "page": const ExpedicaoPage()},
      {"title": "📊 Inventário", "page": const InventarioPage()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false, // agora fica no canto superior ESQUERDO
        elevation: 2,
        actions: [
          // Mensagem de boas-vindas
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                "👋 Bem-vindo, $firstName",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Botão de sair
          IconButton(
            tooltip: "Sair",
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => card["page"] as Widget),
                    );
                  },
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        card["title"].toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Rodapé
          Container(
            width: double.infinity,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(12),
            child: const Center(
              child: Text(
                "© 2025 - Systex Sistemas Inteligentes",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
