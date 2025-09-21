# 📱 Systex WMS 4.0 – App Mobile

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-2.x-blue?logo=dart)](https://dart.dev/)
[![Codemagic](https://img.shields.io/badge/Codemagic-CI%2FCD-brightgreen?logo=codemagic)](https://codemagic.io)
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)]()

Aplicativo mobile **Systex WMS 4.0** desenvolvido em **Flutter** e integrado ao backend Laravel.  
Projetado para rodar em **coletores de dados, tablets e smartphones**, com suporte a funcionamento **online/offline (PWA)**.  

---

## 🚀 Tecnologias Utilizadas
- Flutter 3.x
- Dart 2.x
- Dio (HTTP Client)
- SharedPreferences (armazenamento local)
- Material 3
- Integração REST API com Laravel WMS 4.0

---

## 📂 Estrutura de Pastas
lib/
├── core/ # Configurações, cliente API, storage
├── models/ # Modelos (User, Recebimento, etc.)
├── services/ # Comunicação com API (Auth, Recebimento, etc.)
├── screens/ # Telas (Login, Dashboard, Recebimento, etc.)
├── widgets/ # Componentes reutilizáveis
└── main.dart # Ponto de entrada


---

## ⚙️ Funcionalidades
✅ Login integrado ao backend Laravel  
✅ Dashboard com KPIs em tempo real  
✅ Gestão de Recebimento, Expedição e Inventário  
✅ Contagem de Paletes e Kits  
✅ Suporte a múltiplos usuários e permissões  
✅ PWA para uso em **coletores offline**  
✅ Compatível com Android (APK/AAB) e iOS (IPA)  

---

## 📊 Dashboard
- Indicadores de produtividade por setor  
- KPIs de recebimento, armazenagem e expedição  
- Gráficos em tempo real  

---

## 🔧 Instalação e Build

### Pré-requisitos
- Flutter 3.x  
- Dart SDK  
- Git  
- Android SDK (para gerar APK/AAB)  
- Xcode (para builds iOS)  

### Passos
```bash
# Clonar o repositório
git clone git@github.com:manoelfilhodev/wms_app.git

# Entrar no diretório
cd wms_app

# Instalar dependências
flutter pub get

# Rodar no navegador (modo web)
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0

# Gerar APK (Android)
flutter build apk --release

# Gerar AAB (Android App Bundle)
flutter build appbundle --release

🛠️ Roadmap

📦 Integração completa com módulos de Expedição e Inventário

🔄 Sincronização avançada offline/online (IndexedDB + Laravel Sync)

🔔 Implementação de notificações push

☁️ Publicação contínua via Codemagic

📲 Disponibilização na Google Play e App Store


📜 Licença

Este projeto é de uso interno da Systex Sistemas Inteligentes.
Não é permitido uso comercial sem autorização.

👨‍💻 Autor

Systex Sistemas Inteligentes
🌐 systex.com.br

📧 manoel.filho.mf@icloud.com
