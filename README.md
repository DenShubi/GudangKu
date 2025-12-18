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
