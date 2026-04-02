import 'package:flutter/material.dart';
import 'package:konveksi_bareng/marketplace/pages/bookmark_menu_screen.dart';
import 'package:konveksi_bareng/common/pages/simple_placeholder_page.dart';

const kPurple = Color(0xFF6B257F);

class ProyekDetailScreen extends StatelessWidget {
  final String projectName;
  final String workerName;

  const ProyekDetailScreen({
    super.key,
    required this.projectName,
    required this.workerName,
  });

  @override
  Widget build(BuildContext context) {
    // ===== daftar menu utama (sesuai screenshot) =====
    final rootItems = <BookmarkItem>[
      BookmarkItem.action(
        title: 'jadwal mulai',
        icon: Icons.history_toggle_off_rounded,
        page: SimplePlaceholderPage(title: 'Jadwal Mulai • $projectName'),
      ),
      BookmarkItem.action(
        title: 'jadwal selesai',
        icon: Icons.history_toggle_off_rounded,
        page: SimplePlaceholderPage(title: 'Jadwal Selesai • $projectName'),
      ),
      BookmarkItem.action(
        title: 'SPk nmr',
        icon: Icons.history_toggle_off_rounded,
        page: SimplePlaceholderPage(title: 'SPK Nomor • $projectName'),
      ),
      BookmarkItem.action(
        title: 'nilai harian/borongan',
        icon: Icons.history_toggle_off_rounded,
        page: SimplePlaceholderPage(
          title: 'Nilai Harian/Borongan • $projectName',
        ),
      ),
      BookmarkItem.action(
        title: 'Progress peerjaan',
        icon: Icons.history_toggle_off_rounded,
        page: SimplePlaceholderPage(title: 'Progress Pekerjaan • $projectName'),
      ),

      // Folder: Foto progress pekerjaan
      BookmarkItem.folder(
        title: 'Foto progress pekerjaan',
        icon: Icons.folder_outlined,
        children: [
          BookmarkItem.action(
            title: 'Upload foto',
            icon: Icons.camera_alt_outlined,
            page: SimplePlaceholderPage(
              title: 'Upload Foto Progress • $projectName',
            ),
          ),
          BookmarkItem.action(
            title: 'Galeri foto',
            icon: Icons.photo_library_outlined,
            page: SimplePlaceholderPage(
              title: 'Galeri Foto Progress • $projectName',
            ),
          ),
          BookmarkItem.action(
            title: 'Validasi foto',
            icon: Icons.verified_outlined,
            page: SimplePlaceholderPage(title: 'Validasi Foto • $projectName'),
          ),
        ],
      ),

      BookmarkItem.action(
        title: 'status progress disetujui',
        icon: Icons.history_toggle_off_rounded,
        page: SimplePlaceholderPage(
          title: 'Status Progress Disetujui • $projectName',
        ),
      ),
      BookmarkItem.action(
        title: 'status tagihan',
        icon: Icons.history_toggle_off_rounded,
        page: SimplePlaceholderPage(title: 'Status Tagihan • $projectName'),
      ),

      // Folder: Detail pekerjaan
      BookmarkItem.folder(
        title: 'Detail pekerjaan',
        icon: Icons.folder_outlined,
        children: [
          BookmarkItem.action(
            title: 'Daftar pekerjaan',
            icon: Icons.list_alt_outlined,
            page: SimplePlaceholderPage(
              title: 'Daftar Pekerjaan • $projectName',
            ),
          ),
          BookmarkItem.action(
            title: 'Rincian item',
            icon: Icons.description_outlined,
            page: SimplePlaceholderPage(title: 'Rincian Item • $projectName'),
          ),
          BookmarkItem.action(
            title: 'Catatan lapangan',
            icon: Icons.note_alt_outlined,
            page: SimplePlaceholderPage(
              title: 'Catatan Lapangan • $projectName',
            ),
          ),
        ],
      ),

      BookmarkItem.action(
        title: 'Chat',
        icon: Icons.history_toggle_off_rounded,
        page: SimplePlaceholderPage(title: 'Chat Proyek • $projectName'),
      ),
    ];

    return BookmarkMenuScreen(
      title: projectName,
      subtitle: 'Pekerja: $workerName',
      items: rootItems,
    );
  }
}
