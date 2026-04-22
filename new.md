Detail fitur dan isi project konveksi_bareng
(Diperbarui: 2026-04-11)

=============================================================
GAMBARAN UMUM
=============================================================
- Project Flutter cross-platform dengan package `konveksi_bareng`.
- Framework: Flutter 3.4.0+, Dart 3.4.0+
- Platform didukung: Android, iOS, Web, Windows, macOS, Linux.
- Status: Tahap 3 (Routing) selesai - siap untuk integrasi backend penuh.
- Total: 47 halaman, 11 modul fitur utama.

=============================================================
TECH STACK
=============================================================
- State Management : Provider 6.1.2 (ChangeNotifier)
- Routing          : GoRouter 14.8.1 (47 named routes, fade+slide transition 200ms)
- HTTP Client      : Dio 5.7.0
- Storage          : flutter_secure_storage 9.2.4 (mobile) + shared_preferences 2.2.2 (web)
- Environment      : flutter_dotenv 5.2.1 (load dari .env)
- Device Info      : device_info_plus 12.4.0 (real vs emulator)
- Internationalisasi: intl 0.20.2
- Font             : Poppins (7 varian: Light, Regular, Medium, SemiBold, Bold, ExtraBold, Italic)
- Brand Color      : Purple #6B257F

=============================================================
STRUKTUR FOLDER (AKTUAL)
=============================================================
konveksi_bareng/
├── lib/
│   ├── config/          # Konfigurasi (api_config, app_router, app_theme)
│   ├── models/          # Model data (user_model)
│   ├── providers/       # State management (theme_provider, user_provider, session_guard)
│   ├── services/        # API & storage (api_service, auth_service, storage_service)
│   ├── screens/         # Semua halaman UI (47 file, diorganisir per modul)
│   ├── widgets/         # Widget bersama (auth_background, dll)
│   ├── data/            # Folder kosong (belum digunakan)
│   └── main.dart        # Entry point
├── assets/
│   ├── fonts/           # Font Poppins
│   └── images/          # baju.png, logo.png, logo1.png, bg.png, nike.jpg, dll
├── android/, ios/, web/, windows/, macos/, linux/
├── test/
├── pubspec.yaml
├── .env                 # API_URL (aktif: trycloudflare URL)
├── .env.example         # Template .env
├── PROGRESS.md          # Catatan progress implementasi arsitektur
└── note.txt             # File ini

=============================================================
KONFIGURASI CORE
=============================================================

[api_config.dart]
- Auto-detect platform untuk menentukan base URL:
  - Web              : http://localhost:4001
  - Android Device   : http://192.168.1.6:4001
  - Android Emulator : http://10.0.2.2:4001
  - iOS/Desktop      : http://localhost:4001
- Override via .env (API_URL) untuk production
- Request/receive timeout: 15 detik

[app_theme.dart]
- Light Mode : bg #F7FAFF, ink #0F172A
- Dark Mode  : bg #0B1220, ink #E5E7EB
- 11 warna konstanta: bg, ink, muted, border, card, tile, divider, dll
- Font family: Poppins

[app_router.dart]
- 47 named routes dengan GoRouter
- Initial location: /welcome
- Transisi: Fade + Slide (200ms, Curves.easeOut)
- Group routes: auth, main, finance, project, worker, schedule, inventory, production, marketplace, promotion, common

=============================================================
STATE MANAGEMENT & SERVICES
=============================================================

[ThemeProvider]
- Dark mode toggle (boolean)
- Font size: small (0.9x), medium (1.0x), large (1.1x)
- Shortcut warna dari AppColors

[UserProvider]
- Menyimpan data user global (name, email, phone via UserModel)
- fetchUser() → GET /auth/me
- logout() → clear token & user data

[SessionGuard]
- Polling setiap 15 detik ke GET /auth/me
- Jika 401 → hapus token, trigger logout, redirect ke /welcome

[StorageService]
- Cross-platform: FlutterSecureStorage (mobile) atau SharedPreferences (web)
- Keys: `auth_token`, `pending_email`, `pending_mode`

[ApiService]
- Singleton Dio wrapper
- Base URL dari ApiConfig
- Header: Accept & Content-Type application/json

[AuthService]
Endpoint yang tersedia:
- POST /auth/request-otp          → kirim OTP ke email
- POST /auth/verify-otp           → verifikasi OTP login, response: { token }
- POST /auth/register             → daftarkan user baru
- POST /auth/verify-register-otp  → verifikasi OTP registrasi
- POST /auth/resend-register-otp  → kirim ulang OTP registrasi
- POST /auth/security-questions   → simpan pertanyaan keamanan
- GET  /auth/security-questions   → ambil pertanyaan keamanan
- POST /auth/verify-security-answers → verifikasi jawaban keamanan
- GET  /auth/me                   → ambil profil user (perlu Bearer token)
- POST /auth/logout               → logout (perlu Bearer token)

=============================================================
MODELS
=============================================================

[UserModel] (lib/models/user_model.dart)
- Fields: name, email, phone (semua String, default kosong)
- Factory: UserModel.fromJson(json) → parse dari response /auth/me

Catatan: Model lain (Project, Worker, Product, Transaction) masih berupa
dummy data inline di masing-masing screen, belum dibuat sebagai model terpisah.

=============================================================
AUTH FLOW
=============================================================
1. Welcome Screen → onboarding slider auto-rotate + dot indicator
2. Login → input email → kirim OTP → verifikasi 4-digit → simpan JWT
3. Register → input nama/email/telp → verifikasi OTP → simpan JWT
4. Home → SessionGuard aktif (polling 15 detik)
5. Token expired → auto-logout → redirect /welcome

=============================================================
FITUR APLIKASI (47 HALAMAN)
=============================================================

--- AUTH (7 screens: lib/screens/auth/) ---
- welcome.dart         : Slider onboarding auto-rotate dengan dot indicators
- login.dart           : Form login (email) + request OTP
- register.dart        : Form registrasi (nama, email, nomor telepon)
- verification.dart    : Input 4-digit OTP + resend timer
- find_account.dart    : Recovery akun
- account.dart         : Manajemen akun profil
- security.dart        : Security questions & toggle biometric (UI only)

--- MAIN (5 screens) ---
- home.dart            : Header gradient purple, menu grid fitur, promo section,
                         flash deal, bottom nav custom, sidebar/app drawer,
                         SessionGuard start/stop
- profile.dart         : User info card gaya glass morphism
- settings.dart        : Dark mode toggle, font size (small/medium/large), accordion
- wishlist.dart        : Daftar saved items
- chat.dart            : Daftar chat + group, swipe arsip/hapus, badge unread,
                         search, segmented chips, bottom nav custom

--- FINANCE (10 screens: lib/screens/finance/) ---
- keuangan.dart        : Dashboard keuangan, balance card, income/expense stats,
                         menu grid ke sub-fitur (sebagian label belum dibuat)
- rugi_laba.dart       : Statistik rugi/laba + input transaksi (dummy)
- pembelian.dart       : Riwayat pembelian + kartu pesanan (dummy data)
- penjualan.dart       : Data penjualan (dummy)
- pembayaran.dart      : Status pembayaran (dummy)
- pemasukan.dart       : Daftar pemasukan + filter periode + input bottom sheet (dummy CRUD)
- pengeluaran.dart     : Daftar pengeluaran + filter periode + input bottom sheet (dummy CRUD)
- operasional.dart     : Pengeluaran operasional + aksi export PDF (dummy)
- listrik.dart         : Tagihan listrik + chart 12 bulan + pembayaran (dummy)
- keuanganproyek.dart  : Ringkasan keuangan per proyek (stat, transaksi, quick action)

--- PROJECT MANAGEMENT (6 screens: lib/screens/project/) ---
- kelola_proyek.dart   : Dashboard proyek, menu grid, task group
- daftar_project.dart  : List proyek + filter chips + progress bar (12+ dummy projects)
- proyek_detail.dart   : Detail proyek sederhana
- spk.dart             : Work Order/SPK, status Menunggu/Diproses/Selesai
- meeting.dart         : Daftar meeting + quick action
- buat_meeting.dart    : Form buat meeting (tanggal, waktu, peserta, warna)

--- WORKER (6 screens: lib/screens/worker/) ---
- pekerja.dart         : Hub menu ke sub-fitur pekerja
- daftar_pekerja.dart  : List pekerja searchable + bookmark
- pekerja_detail.dart  : Detail pekerja + proyek terkait
- upah.dart            : Manajemen upah + filter + input + status (dummy CRUD)
- jadwal_upah.dart     : Kalender pembayaran upah (dummy CRUD)
- status_tagihan_upah.dart : Status tagihan upah + search

--- SCHEDULE (4 screens: lib/screens/schedule/) ---
- jadwal.dart          : Hub jadwal, menu grid ke sub-fitur
- jadwal_belanja.dart  : Kalender + daftar jadwal belanja + input sheet (dummy CRUD)
- jadwal_buat.dart     : Kalender + daftar jadwal produksi/pembuatan
- jadwal_kirim.dart    : Kalender + daftar jadwal pengiriman + input sheet (dummy CRUD)

--- INVENTORY (3 screens: lib/screens/inventory/) ---
- bahan_baku.dart      : Dashboard bahan baku, search, kategori, rekomendasi
- pengiriman.dart      : Tracking pengiriman, search/filter, detail timeline
- rencana_belanja.dart : Rencana belanja + status + statistik mini + input sheet (dummy CRUD)

--- PRODUCTION (1 screen: lib/screens/production/) ---
- pola.dart            : Pembuatan pola (pilih file, input detail, qty stepper, form sheet)

--- MARKETPLACE (3 screens: lib/screens/marketplace/) ---
- marketplace.dart     : Katalog produk + promo banner + kategori chips + wishlist (dummy)
- checkout.dart        : Cart review, qty stepper, shipping, ringkasan order
- bookmark_menu_screen.dart : Menu proyek dalam marketplace (bookmark list)

--- PROMOTION (1 screen: lib/screens/promotion/) ---
- promosi.dart         : List promo/voucher + tab + badge + aksi apply/copy (dummy)

--- COMMON (1 screen: lib/screens/common/) ---
- simple_placeholder_page.dart : Placeholder generik untuk fitur belum dibuat

=============================================================
SHARED WIDGETS (lib/widgets/)
=============================================================
- AuthBackground  : Container card dengan background pattern untuk auth screens
- AuthLogo        : Logo header dengan fallback icon
- AuthErrorBox    : Pesan error (merah)
- AuthInfoBox     : Pesan info (biru)
- LanguageDropdown: Pilihan bahasa ID/EN
- AuthBottomBar   : Footer dengan language dropdown + copyright

=============================================================
ASSETS
=============================================================
Fonts: Poppins-Light, Regular, Medium, SemiBold, Bold, ExtraBold, Italic

Images:
- baju.png        : Gambar welcome slide
- logo.png        : Logo brand utama
- logo1.png       : Varian logo
- bg.png          : Pattern background auth
- nike.jpg        : Contoh gambar proyek
- adidas.jpg      : Contoh gambar proyek
- rucas.jpg       : Contoh gambar proyek
- google.png      : Icon social
- facebook.png    : Icon social
- instagram.png   : Icon social

=============================================================
PROGRESS IMPLEMENTASI (PROGRESS.MD)
=============================================================
✅ Tahap 1 - Foundation   : App theme + AppColors + StorageService
✅ Tahap 2 - State        : ThemeProvider + UserProvider + migrasi 42 file ke GoRouter
                            + cleanup 85 unused imports
✅ Tahap 3 - Routing      : GoRouter 47 named routes + fade transition + MaterialApp.router
❌ Tahap 4 - Polish       : Splash screen (flutter_native_splash) - belum dimulai

=============================================================
CATATAN PENTING
=============================================================
- BANYAK AKSI MASIH DUMMY/PLACEHOLDER dan belum terhubung ke backend.
  Yang sudah terhubung API: seluruh modul Auth (login, register, OTP, security, me, logout).
  Yang belum: Finance, Project, Worker, Schedule, Inventory, Production, Marketplace, Promotion.

- Model data (Project, Worker, Product, Transaction, dll) belum dibuat sebagai
  kelas terpisah di lib/models/ — masih inline dummy di masing-masing screen.

- Beberapa screen memiliki 1000+ baris kode karena widget tree belum dipecah
  menjadi komponen lebih kecil.

- Multi-language support (ID/EN) baru ada di auth screens via LanguageDropdown,
  belum diimplementasikan di seluruh aplikasi.

- Fitur biometric di security.dart baru UI, belum ada implementasi backend.

- Referensi arsitektur: project `sso_dash_fe` dari `dashboard_sso`.
