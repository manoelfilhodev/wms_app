import 'package:flutter/material.dart';

class InventarioPage extends StatelessWidget {
  const InventarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventário")),
      body: const Center(
        child: Text("📊 Tela de Inventário"),
      ),
    );
  }
}
