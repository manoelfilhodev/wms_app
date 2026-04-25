# Systex WMS App

Aplicativo mobile do ambiente WMS da Systex Sistemas Inteligentes, desenvolvido em Flutter para apoiar operações de armazém em coletores, tablets e smartphones. O projeto integra módulos operacionais a uma API Laravel e possui base offline-first em evolução para uso em cenários de conectividade instável.

## Objetivo

Fornecer uma interface móvel para execução de processos de WMS, reduzindo dependência de estações fixas e permitindo registro operacional em campo. O app deve preservar dados críticos localmente quando não houver conexão e sincronizar com o backend quando a conectividade retornar.

## Stack

- Flutter e Dart
- Android como alvo operacional principal
- API Laravel
- Dio e HTTP client legado em transição
- SQLite local com `sqflite`
- `shared_preferences`
- `flutter_secure_storage`
- `connectivity_plus`
- Codemagic para CI/CD

## Módulos Principais

- Autenticação: login online com fallback offline.
- Dashboard: entrada para os módulos operacionais.
- Recebimento: fluxo inicial de recebimento e conferência, com integrações pendentes.
- Armazenagem: validação de posição, SKU/EAN e registro de armazenamento.
- Separação: módulo presente, pendente de validação funcional ampla.
- Expedição: módulo presente, pendente de validação funcional ampla.
- Inventário: contagem livre, contagem dirigida e ajustes.
- Inventário cíclico: requisições e itens integrados via API.
- Kits: apontamento de kits/paletes com suporte parcial à sincronização.
- Funcionário Offline: fluxo de referência para CRUD local e sincronização.

## Arquitetura Geral

O aplicativo está organizado em camadas:

- `lib/core`: bootstrap, tema, widgets base, configuração e client de API.
- `lib/modules`: telas e serviços por domínio funcional.
- `lib/services`: autenticação, API, conectividade e token.
- `lib/repositories`: persistência por entidade e regras de acesso a dados.
- `lib/database`: banco local SQLite.
- `lib/sync`: fila, estado e rotinas de sincronização.
- `lib/models`: entidades e objetos de apoio.
- `lib/ui`: telas e widgets ligados ao offline-first.

## Offline-First

O app possui suporte offline principalmente para entidades já conectadas ao SQLite e à fila `sync_queue`. O fluxo atual contempla:

1. Registro local quando não há internet.
2. Marcação de status de sincronização.
3. Enfileiramento de payload.
4. Sincronização automática quando a conexão retorna.
5. Registro de conflitos em `sync_conflicts`.

Nem todos os módulos operacionais estão totalmente offline-first. Cada novo fluxo deve validar impacto em dados locais, API e conflitos antes de ser implementado.

## Instalação

Pré-requisitos:

- Flutter SDK compatível com Dart `>=3.0.0 <4.0.0`
- Git
- Android SDK
- Dispositivo físico ou emulador Android

Comandos:

```bash
flutter pub get
```

## Como Rodar

Ambiente padrão, usando fallback de produção definido no app:

```bash
flutter run
```

Informando API por ambiente:

```bash
flutter run --dart-define=API_BASE_URL=https://host/api
```

Android:

```bash
flutter run -d android
```

Web para diagnóstico:

```bash
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0
```

## Como Testar

Validações recomendadas:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

Observação: a suíte de testes ainda precisa evoluir. O teste atual deve ser revisado para refletir o app real.

## Estrutura de Pastas

```text
lib/
  core/
  database/
  models/
  modules/
  repositories/
  services/
  sync/
  ui/
  utils/
  main.dart
docs/
android/
ios/
web/
test/
assets/
```

## Engenharia

Este projeto segue o Systex AI Engineering Framework descrito em `AGENTS.md`, com atuação coordenada dos agentes ATLAS, ATHENA, PROMETEU, GAIA, VULCAN, ARES, APOLLO, HERMES, ORION e HADES.

## Assinatura Systex

Projeto: Systex WMS App  
Empresa: Systex Sistemas Inteligentes  
Uso: interno ou autorizado  
Licença: proprietária  
Responsável técnico documentado: ver `docs/PROJECT_SIGNATURE.md`
