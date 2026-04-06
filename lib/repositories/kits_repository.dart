import '../database/local_database_service.dart';
import '../models/apontamento_kit.dart';
import '../models/sync_status.dart';
import '../services/api_service.dart';
import '../services/connectivity_service.dart';
import '../sync/sync_service.dart';
import '../utils/user_service.dart';

class KitsRepository {
  KitsRepository({
    LocalDatabaseService? database,
    ConnectivityService? connectivityService,
    SyncService? syncService,
    ApiService? apiService,
  }) : _database = database ?? LocalDatabaseService.instance,
       _connectivity = connectivityService ?? ConnectivityService.instance,
       _syncService = syncService ?? SyncService.instance,
       _apiService = apiService ?? ApiService.instance;

  final LocalDatabaseService _database;
  final ConnectivityService _connectivity;
  final SyncService _syncService;
  final ApiService _apiService;

  Future<List<ApontamentoKit>> listarUltimos({int limit = 10}) async {
    final rows = await _database.query(
      'apontamentos_kits',
      orderBy: 'updated_at DESC',
    );
    return rows.take(limit).map(ApontamentoKit.fromMap).toList();
  }

  Future<ApontamentoKit> apontar({
    required String paleteUid,
  }) async {
    final userId = await UserService.getUserId();
    if (userId == null) {
      throw Exception('Usuário não autenticado');
    }

    final now = DateTime.now();
    final entity = ApontamentoKit(
      paleteUid: paleteUid.trim(),
      codigoMaterial: '', // Será preenchido pela API
      quantidade: 0, // Será preenchido pela API
      status: 'APONTADO',
      apontadoPor: userId,
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
    );

    final idLocal = await _database.insert('apontamentos_kits', entity.toMap());
    final saved = entity.copyWith(idLocal: idLocal);

    await _database.enqueueSync(
      entityType: 'apontamentos_kits',
      entityIdLocal: idLocal,
      action: 'apontar',
      payload: {
        'palete_uid': paleteUid,
        'user_id': userId,
      },
    );

    if (_connectivity.isOnline) {
      await _syncService.runAutoSync();
    }

    return saved;
  }

  Future<void> syncApontamento(int idLocal, Map<String, dynamic> payload) async {
    try {
      final response = await _apiService.dio.post(
        '/kits/apontar-etiqueta',
        data: payload,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 'ok') {
          await _database.updateByLocalId(
            'apontamentos_kits',
            idLocal,
            {'sync_status': SyncStatus.synced.value},
          );
        } else {
          throw Exception(data['mensagem'] ?? 'Erro na API');
        }
      } else {
        throw Exception('Erro HTTP ${response.statusCode}');
      }
    } catch (e) {
      await _database.updateByLocalId(
        'apontamentos_kits',
        idLocal,
        {
          'sync_status': SyncStatus.error.value,
          'error_message': e.toString(),
        },
      );
      rethrow;
    }
  }
}