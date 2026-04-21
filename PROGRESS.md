# 📋 Progress Penerapan Arsitektur (Referensi: sso_dash_fe)

Dokumen ini mencatat progres penerapan pola arsitektur dari `sso_dash_fe` ke `konveksi_bareng`.

---

## 1. Config

| Status | Item | Keterangan |
|--------|------|------------|
| ✅ | `config/api_config.dart` | Auto-detect platform + .env override untuk production |
| ✅ | `config/app_router.dart` | `go_router` + 47 named routes + fade transition |
| ✅ | `config/app_theme.dart` | Theme Light/Dark terpusat + `AppColors` constants |

---

## 2. Providers

| Status | Item | Keterangan |
|--------|------|------------|
| ✅ | `providers/session_guard.dart` | Polling `/auth/me` tiap 15 detik, auto-logout jika 401 |
| ✅ | `providers/theme_provider.dart` | Dark mode toggle + font size (small/medium/large) + shortcut warna |
| ✅ | `providers/user_provider.dart` | State user global, fetch dari `/auth/me`, logout handler |
| ✅ | `main.dart` → `MultiProvider` | Wrap app dengan `ChangeNotifierProvider` (Theme + User) |

---

## 3. Services

| Status | Item | Keterangan |
|--------|------|------------|
| ✅ | `services/auth_service.dart` | Auth flow lengkap + `getMe()` untuk UserProvider |
| ✅ | `services/api_service.dart` | Dio instance terpusat |
| ✅ | `services/storage_service.dart` → Encrypted | `FlutterSecureStorage` di mobile, `SharedPreferences` di web |

---

## 4. Main & UI Polish

| Status | Item | Keterangan |
|--------|------|------------|
| ✅ | `.env` + `flutter_dotenv` | `API_URL=` kosong → auto detect, isi → production/ngrok |
| ❌ | Splash Screen | `flutter_native_splash` untuk loading awal saat mobile |
| ✅ | `main.dart` → `MaterialApp.router` | `MaterialApp.router` + `go_router` + theme switching |

---

## 🔢 Urutan Tahap Implementasi

### Tahap 1 — Foundation (Config & Services) ✅
- [x] `config/app_theme.dart` — buat AppColors + AppTheme (light/dark)
- [x] `services/storage_service.dart` — upgrade ke encrypted storage

### Tahap 2 — State Management (Providers) ✅
- [x] `providers/theme_provider.dart` — dark mode + font size
- [x] `providers/user_provider.dart` — state user global
- [x] `main.dart` → tambah `MultiProvider`
- [x] `models/user_model.dart` — model data user
- [x] `settings.dart` → dark mode pakai ThemeProvider (bukan lokal)

### Tahap 3 — Routing ✅
- [x] `config/app_router.dart` — setup `go_router` + 47 named routes + fade transitions
- [x] `main.dart` → ganti ke `MaterialApp.router`
- [x] Update 42 file: semua `Navigator.push()` → `context.push()` / `context.go()`
- [x] Cleanup 85 unused imports

### Tahap 4 — Polish (nanti akhir)
- [ ] Splash Screen — setup `flutter_native_splash`

---

> **Catatan:** Setiap tahap akan di-update statusnya setelah implementasi selesai.
> Referensi lengkap: `code_fathan/dashboard_sso/sso_dash_fe`

claude --resume 8060b9d9-2e11-467a-b30e-3756081ebea8