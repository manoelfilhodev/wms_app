import 'package:flutter/material.dart';

class ArmazenagemPage extends StatelessWidget {
  const ArmazenagemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Armazenagem")),
      body: const Center(
        child: Text("🏷️ Tela de Armazenagem"),
      ),
    );
  }
}

