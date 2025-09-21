import 'package:flutter/material.dart';

class RecebimentoPage extends StatelessWidget {
  const RecebimentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recebimento")),
      body: const Center(
        child: Text("📦 Tela de Recebimento"),
      ),
    );
  }
}
