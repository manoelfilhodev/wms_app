import 'package:flutter/material.dart';
import '../layout/main_layout.dart';

class ContagemDirigidaPage extends StatelessWidget {
  const ContagemDirigidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MainLayout(
      title: "Contagem Dirigida",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: theme.cardTheme.elevation ?? 3,
          shape: theme.cardTheme.shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Contagem Dirigida",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Esta tela permitirá realizar contagens guiadas baseadas em tarefas de sistema, onde cada operador receberá posições e SKUs pré-designados pelo WMS.",
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 40),
                Center(
                  child: Icon(
                    Icons.map_outlined,
                    color: theme.primaryColor.withOpacity(0.7),
                    size: 72,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Função em desenvolvimento...",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 30),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  label: const Text("Voltar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
