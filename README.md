#📱 Systex WMS 4.0 – App Mobile

Aplicativo mobile (Flutter) integrado ao **Systex WMS 4.0**, projetado para apoiar operações logísticas em dispositivos móveis, tablets e coletores de dados.  
O app permite acompanhar e registrar processos logísticos em tempo real, funcionando tanto online quanto offline (PWA).

---

## 🚀 Tecnologias Utilizadas
- [Flutter](https://flutter.dev/) 3.x
- Dart
- Integração com API Laravel (REST)
- Dio (HTTP Client)
- SharedPreferences (armazenamento local)
- Material 3 + Widgets customizados

---

## 📂 Estrutura de Pastas

lib/
├── core/ # Configurações, cliente API, armazenamento
├── models/ # Modelos (User, Recebimento, etc.)
├── services/ # Comunicação com a API (Auth, Recebimento, etc.)
├── screens/ # Telas (Login, Dashboard, Recebimento, etc.)
├── widgets/ # Componentes reutilizáveis (cards, botões, etc.)
└── main.dart # Ponto de entrada da aplicação


---

## ⚙️ Funcionalidades
✅ Login integrado ao backend Laravel  
✅ Dashboard com KPIs de produtividade  
✅ Gestão de Recebimento (lista e detalhes)  
✅ Expedição e Transferências  
✅ Inventário e Contagem de Paletes/Kits  
✅ Suporte a múltiplos usuários e permissões  
✅ PWA (funcionamento offline/online em coletores)  
✅ Compatível com Android (APK/AAB) e iOS (IPA)  

---

## 📊 Dashboard
- Gráficos de produtividade por setor  
- KPIs de recebimento, armazenagem e expedição  
- Status em tempo real das operações  

---

## 🔧 Instalação e Build

### Pré-requisitos
- Flutter 3.x (instalado e configurado)  
- Dart SDK  
- Git  
- (Opcional) Android SDK / Xcode para builds móveis  

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

Integração completa com módulos de Expedição e Inventário

Sincronização offline/online avançada (IndexedDB + Laravel Sync)

Implementação de notificações push

Publicação na Google Play e App Store

📜 Licença

Este projeto é de uso interno da Systex Sistemas Inteligentes.
Não é permitido uso comercial sem autorização.

👨‍💻 Autor

Systex Sistemas Inteligentes
🌐 systex.com.br

📧 manoel.filho.mf@icloud.com
