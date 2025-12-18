# 📦 GudangKu

<p align="center">
  <img src="assets/images/app_icon.png" alt="GudangKu Logo" width="120"/>
</p>

<p align="center">
  <strong>Aplikasi Manajemen Gudang & Inventaris</strong><br>
  Dibangun dengan Flutter & Supabase
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.9+-02569B?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.9+-0175C2?logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase" alt="Supabase"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey" alt="Platform"/>
</p>

---

## 📱 Tentang Aplikasi

**GudangKu** adalah aplikasi manajemen inventaris/gudang yang membantu pengguna mengelola:
- 📦 **Produk** - Kelola stok barang dengan mudah
- 🏷️ **Kategori** - Organisasi produk berdasarkan kategori
- 🚚 **Supplier** - Manajemen data pemasok
- 👤 **Profil** - Pengaturan akun pengguna

## ✨ Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| 🔐 **Autentikasi** | Login & Register dengan email menggunakan Supabase Auth |
| 📊 **Dashboard** | Ringkasan stok total, stock in, dan stock out |
| 📦 **CRUD Produk** | Tambah, edit, hapus, dan lihat detail produk |
| 🏷️ **Kategori** | Kelola kategori dengan warna kustom |
| 🚚 **Supplier** | Manajemen data supplier lengkap |
| 🖼️ **Upload Gambar** | Upload gambar produk ke Supabase Storage |
| 🔗 **Relasi Database** | Foreign key antara produk, kategori, dan supplier |

## 🛠️ Tech Stack

- **Framework**: Flutter 3.9+
- **State Management**: Provider
- **Backend**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage
- **Architecture**: Feature-based Clean Architecture

## 📁 Struktur Proyek

```
lib/
├── core/
│   ├── constants/      # Warna, tema, konstanta
│   ├── utils/          # Helper functions (currency formatter, dll)
│   └── widgets/        # Widget reusable (button, text field, navbar)
├── features/
│   ├── auth/           # Login, Register, Profile
│   ├── home/           # Dashboard utama
│   ├── product/        # Manajemen produk
│   ├── category/       # Manajemen kategori
│   ├── supplier/       # Manajemen supplier
│   └── intro/          # Splash screen
└── main.dart
```

## 🗄️ Database Schema

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  categories │     │  products   │     │  suppliers  │
├─────────────┤     ├─────────────┤     ├─────────────┤
│ id (PK)     │◄────│ category_id │     │ id (PK)     │
│ name        │     │ supplier_id │────►│ name        │
│ description │     │ id (PK)     │     │ contact     │
│ hex_color   │     │ name        │     │ phone       │
│ is_active   │     │ price       │     │ address     │
│ image_url   │     │ stock       │     │ email       │
└─────────────┘     │ description │     │ notes       │
                    │ image_url   │     │ image_url   │
                    └─────────────┘     └─────────────┘
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9+
- Dart SDK 3.9+
- Supabase Account

### Installation

1. **Clone repository**
   ```bash
   git clone https://github.com/username/gudangku.git
   cd gudangku
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Supabase**
   - Buat project di [Supabase](https://supabase.com)
   - Jalankan SQL migration (lihat `supabase_migration.sql`)
   - Update credentials di `lib/main.dart`:
     ```dart
     await Supabase.initialize(
       url: 'YOUR_SUPABASE_URL',
       anonKey: 'YOUR_ANON_KEY',
     );
     ```

4. **Run aplikasi**
   ```bash
   flutter run
   ```

## 📸 Screenshots

<p align="center">
  <i>Screenshots akan ditambahkan</i>
</p>

## 🤝 Contributing

Kontribusi sangat diterima! Silakan buat pull request atau buka issue untuk saran dan perbaikan.

## 📄 License

Proyek ini dilisensikan di bawah [MIT License](LICENSE).

---

<p align="center">
  Made with ❤️ using Flutter
</p>