import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/systex_glass_card.dart';
import '../../core/widgets/systex_scaffold.dart';
import '../../models/apontamento_kit.dart';
import '../../repositories/kits_repository.dart';
import '../../utils/notifier.dart';

class ApontamentoKitsPage extends StatefulWidget {
  const ApontamentoKitsPage({super.key});

  @override
  State<ApontamentoKitsPage> createState() => _ApontamentoKitsPageState();
}

class _ApontamentoKitsPageState extends State<ApontamentoKitsPage> {
  final _paleteUidController = TextEditingController();
  final _kitsRepository = KitsRepository();

  List<ApontamentoKit> _ultimosApontamentos = [];
  bool _isLoading = false;
  bool _isApontando = false;

  @override
  void initState() {
    super.initState();
    _loadUltimosApontamentos();
  }

  @override
  void dispose() {
    _paleteUidController.dispose();
    super.dispose();
  }

  Future<void> _loadUltimosApontamentos() async {
    setState(() => _isLoading = true);
    try {
      final apontamentos = await _kitsRepository.listarUltimos();
      setState(() => _ultimosApontamentos = apontamentos);
    } catch (e) {
      Notifier.error(context, 'Erro ao carregar apontamentos: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _apontar() async {
    final paleteUid = _paleteUidController.text.trim();
    if (paleteUid.isEmpty) {
      Notifier.warning(context, 'Digite o código do palete');
      return;
    }

    setState(() => _isApontando = true);
    try {
      await _kitsRepository.apontar(paleteUid: paleteUid);
      _paleteUidController.clear();
      Notifier.success(context, 'Apontamento realizado com sucesso!');
      await _loadUltimosApontamentos();
    } catch (e) {
      Notifier.error(context, 'Erro ao apontar: $e');
    } finally {
      setState(() => _isApontando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SystexScaffold(
      title: 'Apontamento de Kits',
      child: RefreshIndicator(
        onRefresh: _loadUltimosApontamentos,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form de apontamento
              SystexGlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Apontar Kit',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _paleteUidController,
                        decoration: const InputDecoration(
                          labelText: 'Código do Palete / QR Code',
                          hintText: 'Digite ou escaneie o código',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _apontar(),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[A-Z0-9\-_\.]'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _isApontando ? null : _apontar,
                        icon: _isApontando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.check_circle),
                        label: Text(_isApontando ? 'Apontando...' : 'Apontar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Últimos apontamentos
              Text(
                'Últimos Apontamentos',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_ultimosApontamentos.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Nenhum apontamento realizado ainda.'),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _ultimosApontamentos.length,
                  itemBuilder: (context, index) {
                    final apontamento = _ultimosApontamentos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(apontamento.paleteUid),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Material: ${apontamento.codigoMaterial}'),
                            Text('Qtd: ${apontamento.quantidade}'),
                            Text('Status: ${apontamento.status}'),
                          ],
                        ),
                        trailing: Text(
                          apontamento.updatedAt.toString().split(' ')[0],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}