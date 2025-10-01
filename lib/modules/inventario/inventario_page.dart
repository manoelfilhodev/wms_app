import 'package:flutter/material.dart';
import 'contagem_livre_page.dart';

class InventarioPage extends StatelessWidget {
  const InventarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventarioCards = [
      {"title": "📋 Contagem Livre", "page": const ContagemLivrePage()},
      {"title": "📌 Contagem Dirigida", "page": null}, // em desenvolvimento
      {"title": "⚖️ Ajustes de Estoque", "page": null}, // em desenvolvimento
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventário"),
        elevation: 2,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: inventarioCards.length,
        itemBuilder: (context, index) {
          final card = inventarioCards[index];
          return GestureDetector(
            onTap: () {
              if (card["page"] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => card["page"] as Widget),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Funcionalidade em desenvolvimento..."),
                  ),
                );
              }
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
    );
  }
}
