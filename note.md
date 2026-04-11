Detail fitur dan isi project konveksi_bareng

Gambaran umum
- Project Flutter dengan package `konveksi_bareng`.
- Struktur platform standar tersedia: `android`, `ios`, `web`, `windows`, `macos`, `linux`.

Struktur level-atas
- `lib`: sumber kode aplikasi.
- `test`: unit/widget test.
- `pubspec.yaml`: metadata proyek + dependencies.
- `analysis_options.yaml`: lint/analisis.
- `README.md`: ringkasan proyek.
- `.dart_tool`, `.idea`, `.iml`, `.git`, `.gitignore`: tooling dan Git.

Entry point & service
- `lib/main.dart`: entry point aplikasi.
- `lib/service/api_service.dart`: service API berbasis Dio (wrapper request).

Core
- `lib/core/constants/`: tempat konstanta aplikasi.
- `lib/core/theme/`: tema/styling.
- `lib/core/utils/`: utilitas umum.
- `lib/core/widgets/`: widget bersama.

Fitur aplikasi (berdasarkan `lib/features`)

Auth
- `welcome.dart`: halaman welcome/onboarding dengan indikator dot.
- `login.dart`: form login.
- `register.dart`: form registrasi dengan validasi (nama, telp, email, password, konfirmasi password).
- `auth_service.dart`: layanan auth utama.
- `auth_service_emu.dart`: layanan auth untuk emulator.
- `auth_service_hp.dart`: layanan auth untuk device.
- `token_store.dart`: penyimpanan token (file saat ini kosong).

Chat
- `chat.dart`: layar chat dengan header gradient, search, segmented chips, daftar chat & group.
  - Ada aksi swipe (arsip/hapus) dan badge unread.
  - Ada bottom nav bar custom.

Common
- `simple_placeholder_page.dart`: halaman placeholder sederhana untuk fitur yang belum dibuat.

Finance
- `keuangan.dart`: dashboard keuangan + menu grid ke fitur lain (sebagian label bertanda �belum dibuat�).
- `keuanganproyek.dart`: ringkasan keuangan proyek (stat, transaksi, quick action).
- `pemasukan.dart`: daftar pemasukan dengan filter periode + input bottom sheet (dummy CRUD).
- `pengeluaran.dart`: daftar pengeluaran dengan filter periode + input bottom sheet (dummy CRUD).
- `operasional.dart`: pengeluaran operasional + aksi export PDF (dummy).
- `rugi_laba.dart`: rugi/laba dengan statistik + input transaksi (dummy).
- `pembelian.dart`: riwayat pembelian dan ringkasan (dummy data) + kartu pesanan.
- `listrik.dart`: tagihan listrik dengan chart 12 bulan + pembayaran (dummy).

Home
- `home.dart`: halaman utama dengan:
  - header, promo section, menu grid fitur, highlight produk/flash deal, dan bottom nav.
  - sidebar/app drawer khusus.

Inventory
- `bahan_baku.dart`: dashboard bahan baku dengan search, quick menu, kategori, rekomendasi produk.
- `pengiriman.dart`: tracking pengiriman dengan search/filter, detail timeline, sheet tracking.
- `rencana_belanja.dart`: rencana belanja dengan status, statistik mini, input sheet (dummy CRUD).

Marketplace
- `marketplace.dart`: katalog produk + promo banner, kategori, wishlist (aksi dummy).
- `wishlist.dart`: daftar wishlist dengan search dan notifikasi dummy.
- `checkout.dart`: halaman checkout (cart item, qty, shipping, ringkasan).
- `bookmark_menu_screen.dart`: menu proyek dalam marketplace (bookmark list).

Production
- `pola.dart`: pembuatan pola (pilih file, input detail, qty stepper, sheet form).

Profile
- `profile.dart`: profil pengguna dengan kartu gaya glass/gradient, statistik mini, form/menulist.
- `settings.dart`: pengaturan dengan accordion/switch, menu list (gaya UI serupa profil).

Project
- `kelola_proyek.dart`: dashboard kelola proyek (menu grid, in-progress, task group).
- `daftar_project.dart`: daftar proyek + filter chips + card proyek.
- `meeting.dart`: daftar meeting, quick action, dan navigasi.
- `buat_meeting.dart`: form buat meeting (tanggal, waktu, peserta, warna, dsb).
- `spk.dart`: daftar SPK + form membuat SPK (status: Menunggu/Diproses/Selesai).
- `proyek_detail.dart`: detail proyek sederhana.

Promotion
- `promosi.dart`: daftar promo/voucher dengan tab, badge, dan aksi apply/copy (dummy).

Schedule
- `jadwal.dart`: hub jadwal + menu grid ke sub-fitur jadwal.
- `jadwal_belanja.dart`: kalender + daftar jadwal belanja + input sheet (dummy CRUD).
- `jadwal_buat.dart`: kalender + daftar jadwal pembuatan.
- `jadwal_kirim.dart`: kalender + daftar jadwal pengiriman + input sheet (dummy CRUD).

Worker
- `pekerja.dart`: menu pekerja (akses daftar/fitur pekerja lainnya).
- `daftar_pekerja.dart`: daftar pekerja + search + detail.
- `pekerja_detail.dart`: detail pekerja + proyek terkait.
- `status_tagihan_upah.dart`: daftar status tagihan upah + search.
- `upah.dart`: manajemen upah dengan filter, input, dan status (dummy CRUD).
- `jadwal_upah.dart`: jadwal pembayaran upah berbasis kalender (dummy CRUD).

Catatan
- Banyak aksi bertanda �dummy�/placeholder dan belum terhubung ke backend.
- Detail UI spesifik (label, komponen) tertanam di masing-masing `pages/*.dart`.