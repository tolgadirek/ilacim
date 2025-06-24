# 💊 İlacım

Flutter ile geliştirilen **İlacım**, kullanıcılara günlük ilaçlarını zamanında almaları için bildirimlerle hatırlatma yapan bir mobil uygulamadır. Firebase ile entegre çalışan uygulama, kullanıcı profili, ilaç yönetimi ve istatistiksel takip özellikleri sunar.

## 🚀 Özellikler

- 🔔 **İlaç Hatırlatma Bildirimleri**  
  Kullanıcılar ilaç saatlerini belirleyebilir, uygulama zamanında bildirim göndererek hatırlatma yapar.

- 📊 **Haftalık İlaç Kullanım İstatistikleri**  
  Günlük kullanılan ilaçlar üzerinden haftalık grafiksel analizler.

- 🧑‍⚕️ **Kullanıcı Profili Yönetimi**  
  Firebase üzerinden kullanıcı adı, soyadı, doğum tarihi gibi bilgiler görüntülenebilir.

- 💾 **Veri Saklama (Firestore)**  
  Tüm kullanıcı ve ilaç verileri Firebase Firestore üzerinde güvenli şekilde saklanır.

- ⚙️ **Cubit ile Durum Yönetimi (Bloc Architecture)**  
  Temiz ve modüler yapıya sahip bir Cubit mimarisi ile yönetilen sayfalar.

## 📱 Ekranlar

- `Anasayfa`: Günün ilaçları ve bildirimleri
- `İlaçlar`: İlaç ekleme, silme, listeleme
- `İstatistik`: Haftalık kullanım verisi
- `Hesabım`: Profil bilgileri ve bildirim ayarları
- `Değerlendirme`: Uygulama gelişimi için yorum yapma

## 📦 Kullanılan Paketler

- flutter_bloc
- firebase_core
- firebase_auth
- cloud_firestore
- intl
- fl_chart
- flutter_local_notifications
- timezone
- shared_preferences

## 🛠️ Kurulum

### Gereksinimler

- Flutter SDK
- Dart SDK
- Firebase projesi oluşturulmuş olmalı (Firestore, Authentication, vb.)
- Android Studio veya VS Code

### Adımlar

```bash
git clone https://github.com/tolgadirek/ilacim.git
cd ilacim
flutter pub get
flutter run
```
Not: Firebase bağlantısını sağlamak için google-services.json dosyasını projenin ilgili dizinlerine eklemeyi unutmayın.
