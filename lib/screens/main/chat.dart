// chat.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/screens/main/chat_conversation_screen.dart';

const kPurple = Color(0xFF6B257F);

class ChatScreen extends StatefulWidget {
  final String? prevRoute;

  const ChatScreen({super.key, this.prevRoute});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

// NOTE: duplicate createState extension removed

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchC = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  // true = Chats, false = Groups
  bool _showChats = true;
  bool _isSearching = false;

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
      message: 'Iâ€™m not gonna pay you.',
      time: '2:46 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 0,
      isRead: false,
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
    _searchFocus.dispose();
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
      backgroundColor: Theme.of(context).appColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER GRADIENT =====
            _HeaderGradient(
              onBack: () {
                if (widget.prevRoute != null && widget.prevRoute!.isNotEmpty) {
                  context.go(widget.prevRoute!);
                } else if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
              onNotif: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                    pageBuilder: (_, __, ___) =>
                        const _ChatNotificationsScreen(),
                  ),
                );
              },
              isSearching: _isSearching,
              searchController: _searchC,
              searchFocusNode: _searchFocus,
              onOpenSearch: () {
                setState(() => _isSearching = true);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    _searchFocus.requestFocus();
                  }
                });
              },
              onCloseSearch: () {
                _searchC.clear();
                _searchFocus.unfocus();
                setState(() {
                  _isSearching = false;
                  _query = '';
                });
              },
              onSearchChanged: (v) => setState(() => _query = v),
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
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (_showChats) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ChatConversationScreen(
                            contactName: 'Pesan Baru',
                          ),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Buat group (placeholder)')),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).appColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Theme.of(context).appColors.border),
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ChatConversationScreen(
                                contactName: item.name,
                                avatarUrl: item.avatarUrl,
                              ),
                            ));
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ChatConversationScreen(
                                contactName: g.name,
                                isGroup: true,
                                memberCount: g.members,
                              ),
                            ));
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
  final VoidCallback onBack;
  final VoidCallback onNotif;
  final bool isSearching;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onOpenSearch;
  final VoidCallback onCloseSearch;
  final ValueChanged<String> onSearchChanged;

  const _HeaderGradient({
    required this.onBack,
    required this.onNotif,
    required this.isSearching,
    required this.searchController,
    required this.searchFocusNode,
    required this.onOpenSearch,
    required this.onCloseSearch,
    required this.onSearchChanged,
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
              if (isSearching)
                Expanded(
                  child: _SearchPillBetter(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    onChanged: onSearchChanged,
                    onClear: onCloseSearch,
                  ),
                )
              else ...[
                _HeaderIcon(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: onBack,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Chat',
                    style: TextStyle(
                      color: Theme.of(context).appColors.card,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _HeaderIcon(
                  icon: Icons.search_rounded,
                  onTap: onOpenSearch,
                ),
                const SizedBox(width: 10),
                _HeaderIcon(
                  icon: Icons.notifications_none_rounded,
                  onTap: onNotif,
                ),
              ],
            ],
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
          color: Theme.of(context).appColors.card.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: Theme.of(context).appColors.card.withValues(alpha: 0.16)),
        ),
        child: Icon(icon, color: Theme.of(context).appColors.card, size: 20),
      ),
    );
  }
}

class _SearchPillBetter extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchPillBetter({
    required this.controller,
    this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context).appColors.card.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 20, color: Colors.white70),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search chat / group...',
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).appColors.card,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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

class _ChatNotificationsScreen extends StatelessWidget {
  const _ChatNotificationsScreen();

  static const _items = [
    _ChatNotificationItem(
      title: 'Pesan baru dari Chloe',
      subtitle: 'Hello! Are you available for tonight?',
      time: '2 menit lalu',
      contactName: 'Chloe',
      avatarUrl: 'https://placehold.co/80x80',
      unread: true,
      icon: Icons.chat_bubble_outline,
    ),
    _ChatNotificationItem(
      title: 'Group Penjahit',
      subtitle: 'Admin: besok meeting jam 10',
      time: '18 menit lalu',
      contactName: 'Group Penjahit',
      isGroup: true,
      memberCount: 128,
      unread: true,
      icon: Icons.groups_2_outlined,
    ),
    _ChatNotificationItem(
      title: 'Pesan belum dibaca',
      subtitle: 'Kaitlyn mengirim pesan terakhir hari ini',
      time: '1 jam lalu',
      contactName: 'Kaitlyn',
      avatarUrl: 'https://placehold.co/80x80',
      unread: false,
      icon: Icons.mark_chat_unread_outlined,
    ),
    _ChatNotificationItem(
      title: 'Group Supplier Kain',
      subtitle: 'Harga combed naik 2k/meter',
      time: 'Kemarin',
      contactName: 'Group Supplier Kain',
      isGroup: true,
      memberCount: 203,
      unread: false,
      icon: Icons.storefront_outlined,
    ),
  ];

  void _openNotification(BuildContext context, _ChatNotificationItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatConversationScreen(
          contactName: item.contactName,
          avatarUrl: item.avatarUrl,
          isGroup: item.isGroup,
          memberCount: item.memberCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _CircleBackButton(onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Notifikasi Chat',
                      style: TextStyle(
                        color: Theme.of(context).appColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _ChatNotificationTile(
                    item: item,
                    onTap: () => _openNotification(context, item),
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

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CircleBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).appColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: Theme.of(context).appColors.ink,
          size: 20,
        ),
      ),
    );
  }
}

class _ChatNotificationTile extends StatelessWidget {
  final _ChatNotificationItem item;
  final VoidCallback onTap;

  const _ChatNotificationTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: item.unread
                ? const Color(0xFFE3C7F0)
                : Theme.of(context).appColors.border,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.unread
                    ? const Color(0xFFF3E4FF)
                    : Theme.of(context).appColors.iconSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                item.icon,
                color:
                    item.unread ? kPurple : Theme.of(context).appColors.muted,
                size: 22,
              ),
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
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).appColors.ink,
                            fontSize: 13.5,
                            fontWeight:
                                item.unread ? FontWeight.w900 : FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: TextStyle(
                          color: Theme.of(context).appColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            if (item.unread) ...[
              const SizedBox(width: 10),
              Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: kPurple,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChatNotificationItem {
  final String title;
  final String subtitle;
  final String time;
  final String contactName;
  final String? avatarUrl;
  final bool isGroup;
  final int? memberCount;
  final bool unread;
  final IconData icon;

  const _ChatNotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.contactName,
    this.avatarUrl,
    this.isGroup = false,
    this.memberCount,
    required this.unread,
    required this.icon,
  });
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
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).appColors.border),
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
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).appColors.card,
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
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          item.time,
                          style: TextStyle(
                            color: Theme.of(context).appColors.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).appColors.muted,
                              fontSize: 13,
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
      child: Icon(icon, color: Color(0xFF6B6B6B), size: 22),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;
  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kPurple,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: Theme.of(context).appColors.card,
          fontSize: 11,
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
              color: bg.withValues(alpha: 0.22),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: TextStyle(
                  color: bg,
                  fontSize: 16,
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
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Theme.of(context).appColors.border),
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
                          style: TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        group.time,
                        style: TextStyle(
                          color: Theme.of(context).appColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    group.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${group.members} members â€¢ ${group.subtitle}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 11,
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
