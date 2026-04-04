// chat.dart
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:konveksi_bareng/screens/main/home.dart';
import 'package:konveksi_bareng/screens/marketplace/wishlist.dart';
import 'package:konveksi_bareng/screens/profile/settings.dart';
import 'package:konveksi_bareng/screens/profile/profile.dart';

const kPurple = Color(0xFF6B257F);

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

// NOTE: typo fix (CreateState -> createState)
extension _FixState on ChatScreen {
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchC = TextEditingController();

  // true = Chats, false = Groups
  bool _showChats = true;

  String _query = '';

  // Dummy chats
  final List<_ChatItem> _chats = [
    _ChatItem(
      name: 'Kaitlyn',
      message: 'Have a good one!',
      time: '3:02 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 0,
      isRead: true,
    ),
    _ChatItem(
      name: 'Chloe',
      message: 'Hello! Are you available for toni...',
      time: '2:58 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 2,
      isRead: false,
    ),
    _ChatItem(
      name: 'X Client',
      message: 'I’m not gonna pay you.',
      time: '2:46 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 0,
      isRead: false,
      selected: true,
    ),
    _ChatItem(
      name: 'Phoebe',
      message: 'Good bye!',
      time: '2:41 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 0,
      isRead: true,
    ),
    _ChatItem(
      name: 'Jack',
      message: 'See you again!',
      time: '2:27 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 0,
      isRead: true,
    ),
    _ChatItem(
      name: 'Gibson',
      message: 'Okay, Thank you!',
      time: '2:16 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 0,
      isRead: true,
    ),
  ];

  // Dummy groups
  final List<_GroupItem> _groups = const [
    _GroupItem(
      name: 'Group Penjahit',
      subtitle: 'Diskusi jahit & standar QC',
      members: 128,
      lastMessage: 'Admin: besok meeting jam 10',
      time: '1:20 PM',
      icon: Icons.cut,
    ),
    _GroupItem(
      name: 'Group Hoodie',
      subtitle: 'Bahan, pola, ukuran hoodie',
      members: 87,
      lastMessage: 'Rina: kain fleece bagus yang mana?',
      time: '12:05 PM',
      icon: Icons.checkroom,
    ),
    _GroupItem(
      name: 'Group Packaging',
      subtitle: 'Poly mailer, box, label',
      members: 52,
      lastMessage: 'Aji: stok box size M aman',
      time: 'Yesterday',
      icon: Icons.inventory_2_outlined,
    ),
    _GroupItem(
      name: 'Group Supplier Kain',
      subtitle: 'Harga kain & rekomendasi supplier',
      members: 203,
      lastMessage: 'Harga combed naik 2k/meter',
      time: 'Yesterday',
      icon: Icons.storefront_outlined,
    ),
    _GroupItem(
      name: 'Group Produksi',
      subtitle: 'Timeline produksi & koordinasi',
      members: 64,
      lastMessage: 'Deadline batch #12: Jumat',
      time: 'Mon',
      icon: Icons.factory_outlined,
    ),
  ];

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatsFiltered = _chats.where((e) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return e.name.toLowerCase().contains(q) ||
          e.message.toLowerCase().contains(q);
    }).toList();

    final groupsFiltered = _groups.where((g) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return g.name.toLowerCase().contains(q) ||
          g.subtitle.toLowerCase().contains(q) ||
          g.lastMessage.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      bottomNavigationBar: const _BottomNavBar(activeIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER GRADIENT =====
            _HeaderGradient(
              onNotif: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Notifikasi')));
              },
              searchController: _searchC,
              onSearchChanged: (v) => setState(() => _query = v),
              onClear: () {
                _searchC.clear();
                setState(() => _query = '');
              },
            ),

            const SizedBox(height: 12),

            // ===== TITLE + ACTION =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _showChats ? 'Recent Chats' : 'Groups',
                      style: const TextStyle(
                        color: Color(0xFF1F1F1F),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _showChats
                                ? 'New message (dummy)'
                                : 'Create group (dummy)',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE8ECF4)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _showChats ? Icons.edit_outlined : Icons.group_add,
                            size: 18,
                            color: kPurple,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _showChats ? 'New' : 'Create',
                            style: const TextStyle(
                              color: kPurple,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ===== SEGMENTED (CHIPS STYLE) =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SegmentedChips(
                activeLeft: _showChats,
                left: 'Chats',
                right: 'Groups',
                onTapLeft: () => setState(() => _showChats = true),
                onTapRight: () => setState(() => _showChats = false),
              ),
            ),

            const SizedBox(height: 12),

            // ===== LIST CONTENT =====
            Expanded(
              child: _showChats
                  ? ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: chatsFiltered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final item = chatsFiltered[i];
                        return _SwipeChatRow(
                          item: item,
                          onOpen: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Buka chat: ${item.name}'),
                              ),
                            );
                          },
                          onArchive: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Arsip: ${item.name}')),
                            );
                          },
                          onDelete: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Hapus: ${item.name}')),
                            );
                          },
                        );
                      },
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: groupsFiltered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final g = groupsFiltered[i];
                        return _GroupRow(
                          group: g,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Buka group: ${g.name}')),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ===================== HEADER (GRADIENT + SEARCH) =====================
//
class _HeaderGradient extends StatelessWidget {
  final VoidCallback onNotif;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClear;

  const _HeaderGradient({
    required this.onNotif,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B257F), Color(0xFF4F1E63)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Back
              _HeaderIcon(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              // Notif
              _HeaderIcon(
                icon: Icons.notifications_none_rounded,
                onTap: onNotif,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SearchPillBetter(
            controller: searchController,
            onChanged: onSearchChanged,
            onClear: onClear,
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.16)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _SearchPillBetter extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchPillBetter({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search chat / group...',
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.close, size: 18, color: Colors.white70),
              ),
            ),
        ],
      ),
    );
  }
}

//
// ===================== SEGMENTED CHIPS =====================
//
class _SegmentedChips extends StatelessWidget {
  final String left;
  final String right;
  final bool activeLeft;
  final VoidCallback onTapLeft;
  final VoidCallback onTapRight;

  const _SegmentedChips({
    required this.left,
    required this.right,
    required this.activeLeft,
    required this.onTapLeft,
    required this.onTapRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ChipItem(text: left, active: activeLeft, onTap: onTapLeft),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ChipItem(
              text: right,
              active: !activeLeft,
              onTap: onTapRight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _ChipItem({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFF3E4FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? const Color(0xFFE3C7F0) : Colors.transparent,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? kPurple : const Color(0xFF6B7280),
            fontSize: 13,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

//
// ===================== MODELS =====================
//
class _ChatItem {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final int unread;
  final bool isRead;
  final bool selected;

  _ChatItem({
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    required this.unread,
    required this.isRead,
    this.selected = false,
  });
}

class _GroupItem {
  final String name;
  final String subtitle;
  final int members;
  final String lastMessage;
  final String time;
  final IconData icon;

  const _GroupItem({
    required this.name,
    required this.subtitle,
    required this.members,
    required this.lastMessage,
    required this.time,
    required this.icon,
  });
}

//
// ===================== CHAT ROW (SWIPE) =====================
//
class _SwipeChatRow extends StatelessWidget {
  final _ChatItem item;
  final VoidCallback onOpen;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  const _SwipeChatRow({
    required this.item,
    required this.onOpen,
    required this.onArchive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('chat_${item.name}'),
      background: const _SwipeBg(
        color: Color(0xFFEBEDFF),
        icon: Icons.folder_outlined,
        alignLeft: true,
      ),
      secondaryBackground: const _SwipeBg(
        color: Color(0xFFFFE7E5),
        icon: Icons.delete_outline,
        alignLeft: false,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onArchive();
        } else {
          onDelete();
        }
        return false;
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onOpen,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: item.selected
                  ? const Color(0xFFB58BC8)
                  : const Color(0xFFE8ECF4),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              _AvatarNetwork(url: item.avatarUrl, name: item.name),
              const SizedBox(width: 12),

              // text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.time,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 11,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF4B5563),
                              fontSize: 13,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (item.unread > 0) _UnreadBadge(count: item.unread),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeBg extends StatelessWidget {
  final Color color;
  final IconData icon;
  final bool alignLeft;

  const _SwipeBg({
    required this.color,
    required this.icon,
    required this.alignLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(icon, color: const Color(0xFF6B6B6B), size: 22),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;
  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kPurple,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _AvatarNetwork extends StatelessWidget {
  final String url;
  final String name;

  const _AvatarNetwork({required this.url, required this.name});

  Color _seedColor(String s) {
    final r = Random(s.hashCode);
    return Color.fromARGB(
      255,
      120 + r.nextInt(80),
      80 + r.nextInt(80),
      140 + r.nextInt(80),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = _seedColor(name);
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 46,
        height: 46,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              color: bg.withOpacity(0.22),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: TextStyle(
                  color: bg,
                  fontSize: 16,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w900,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//
// ===================== GROUP ROW =====================
//
class _GroupRow extends StatelessWidget {
  final _GroupItem group;
  final VoidCallback onTap;

  const _GroupRow({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8ECF4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF3E4FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(group.icon, color: kPurple, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 14,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        group.time,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 11,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    group.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF4B5563),
                      fontSize: 13,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${group.members} members • ${group.subtitle}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 11,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ================== BOTTOM NAV (CHAT ACTIVE) ==================
//
class _BottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _BottomNavBar({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8ECF4))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            label: 'Home',
            icon: Icons.home_filled,
            active: activeIndex == 0,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          _NavItem(
            label: 'Wishlist',
            icon: Icons.favorite_border,
            active: activeIndex == 1,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
          ),
          _NavItem(
            label: 'Settings',
            icon: Icons.settings_outlined,
            active: activeIndex == 2,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          _NavItem(
            label: 'Chat',
            icon: Icons.chat_bubble_outline,
            active: activeIndex == 3,
            onTap: () {},
          ),
          _NavItem(
            label: 'Profile',
            icon: Icons.person_outline,
            active: activeIndex == 4,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? kPurple : const Color(0xFFC9CBCE);
    final fontWeight = active ? FontWeight.w800 : FontWeight.w500;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
