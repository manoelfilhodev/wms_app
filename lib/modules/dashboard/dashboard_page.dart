import 'package:flutter/material.dart';
import '../recebimento/pages/recebimento_page.dart';
import '../armazenagem/armazenagem_page.dart';
import '../separacao/separacao_page.dart';
import '../expedicao/expedicao_page.dart';
import '../inventario/inventario_page.dart';
import '../auth/login_page.dart';

class DashboardPage extends StatelessWidget {
  final String userName;

  const DashboardPage({super.key, this.userName = "Usuário"});

  String get firstName {
    if (userName.trim().isEmpty) return "Usuário";
    return userName.split(" ").first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final crossCount = screenWidth > 900
        ? 4
        : screenWidth > 600
            ? 3
            : 2;

    final modules = [
      {
        "title": "📦 Recebimento",
        "subtitle": "Entrada e conferência de mercadorias",
        "page": RecebimentoPage(),
        "icon": Icons.inventory_2_outlined,
      },
      {
        "title": "🏷️ Armazenagem",
        "subtitle": "Movimentação e localização de produtos",
        "page": ArmazenagemPage(),
        "icon": Icons.move_down_outlined,
      },
      {
        "title": "📑 Separação",
        "subtitle": "Picking e preparação de pedidos",
        "page": SeparacaoPage(),
        "icon": Icons.playlist_add_check_circle_outlined,
      },
      {
        "title": "🚚 Expedição",
        "subtitle": "Saída e transporte de mercadorias",
        "page": ExpedicaoPage(),
        "icon": Icons.local_shipping_outlined,
      },
      {
        "title": "📊 Inventário",
        "subtitle": "Controle e contagem de estoque",
        "page": InventarioPage(),
        "icon": Icons.analytics_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: theme.cardTheme.color?.withOpacity(0.98),
        title: Row(
          children: [
            Icon(Icons.dashboard_outlined,
                color: theme.primaryColor.withOpacity(0.85)),
            const SizedBox(width: 8),
            Text(
              "Painel de Controle",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Icon(Icons.account_circle_outlined,
                    color: theme.primaryColor, size: 22),
                const SizedBox(width: 6),
                Text(
                  "Olá, $firstName",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: "Sair do sistema",
                  icon: Icon(Icons.logout_rounded,
                      color: theme.primaryColor, size: 22),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => module["page"] as Widget),
                    );
                  },
                  child: Card(
                    elevation: theme.cardTheme.elevation ?? 3,
                    shape: theme.cardTheme.shape ??
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                    color: theme.cardTheme.color?.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            module["icon"] as IconData,
                            color: theme.primaryColor,
                            size: 36,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            module["title"].toString(),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            module["subtitle"].toString(),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 35,
                            height: 3,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
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
            padding: const EdgeInsets.all(14),
            color: theme.cardTheme.color?.withOpacity(0.96),
            child: Column(
              children: [
                Text(
                  "© 2025 • Systex Sistemas Inteligentes",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Infraestrutura em Azure • Backend Laravel 10 • API Segura via SSL",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
