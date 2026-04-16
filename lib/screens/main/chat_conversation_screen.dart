// lib/screens/main/chat_conversation_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konveksi_bareng/config/app_colors.dart';

const _kPurple = Color(0xFF6B257F);

// ── Message model ─────────────────────────────────────────────────────────────

class _Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;
  final bool isRead;

  _Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = false,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────

class ChatConversationScreen extends StatefulWidget {
  final String contactName;
  final String? avatarUrl;
  final bool isGroup;
  final int? memberCount;

  const ChatConversationScreen({
    super.key,
    required this.contactName,
    this.avatarUrl,
    this.isGroup = false,
    this.memberCount,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _inputC = TextEditingController();
  final ScrollController _scrollC = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  late final List<_Message> _messages = _seedMessages();

  List<_Message> _seedMessages() {
    final now = DateTime.now();
    return [
      _Message(
          id: '1',
          text: 'Halo! Ada yang bisa dibantu?',
          isMe: false,
          time: now.subtract(const Duration(minutes: 42)),
          isRead: true),
      _Message(
          id: '2',
          text: 'Hei, mau tanya soal pesanan batch terakhir.',
          isMe: true,
          time: now.subtract(const Duration(minutes: 40)),
          isRead: true),
      _Message(
          id: '3',
          text: 'Boleh, pesanan nomor berapa?',
          isMe: false,
          time: now.subtract(const Duration(minutes: 39)),
          isRead: true),
      _Message(
          id: '4',
          text: 'ORD-240101-003, Kemeja Oxford 20 pcs.',
          isMe: true,
          time: now.subtract(const Duration(minutes: 38)),
          isRead: true),
      _Message(
          id: '5',
          text:
              'Oke, sudah dicek. Sedang dalam proses jahit, estimasi selesai 2 hari lagi.',
          isMe: false,
          time: now.subtract(const Duration(minutes: 35)),
          isRead: true),
      _Message(
          id: '6',
          text: 'Oke siap, terima kasih infonya!',
          isMe: true,
          time: now.subtract(const Duration(minutes: 34)),
          isRead: true),
      _Message(
          id: '7',
          text: 'Sama-sama 😊',
          isMe: false,
          time: now.subtract(const Duration(minutes: 10)),
          isRead: true),
    ];
  }

  @override
  void initState() {
    super.initState();
    _inputC.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _inputC.dispose();
    _scrollC.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = false}) {
    if (!_scrollC.hasClients) return;
    if (animated) {
      _scrollC.animateTo(_scrollC.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      _scrollC.jumpTo(_scrollC.position.maxScrollExtent);
    }
  }

  void _sendMessage() {
    final text = _inputC.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isMe: true,
        time: DateTime.now(),
      ));
      _inputC.clear();
      _isTyping = true;
    });

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToBottom(animated: true));

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final replies = [
        'Oke, noted!',
        'Siap, akan segera diproses.',
        'Terima kasih infonya 👍',
        'Baik, kami akan follow up segera.',
        'Sudah dicatat ya!',
        'Oke, nanti kami konfirmasi lagi.',
      ];
      setState(() {
        _isTyping = false;
        _messages.add(_Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: replies[Random().nextInt(replies.length)],
          isMe: false,
          time: DateTime.now(),
          isRead: true,
        ));
      });
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _scrollToBottom(animated: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colors.bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _ConvHeader(
              name: widget.contactName,
              avatarUrl: widget.avatarUrl,
              isGroup: widget.isGroup,
              memberCount: widget.memberCount,
              isTyping: _isTyping,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _focusNode.unfocus(),
                child: ListView.builder(
                  controller: _scrollC,
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.03, 12, screenWidth * 0.03, 8),
                  itemCount: _messages.length,
                  itemBuilder: (context, i) {
                    final msg = _messages[i];
                    final prev = i > 0 ? _messages[i - 1] : null;
                    final showDate =
                        prev == null || !_sameDay(prev.time, msg.time);
                    return Column(
                      children: [
                        if (showDate) _DateDivider(date: msg.time),
                        _MessageBubble(
                          msg: msg,
                          screenWidth: screenWidth,
                          colors: colors,
                          isDark: isDark,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  children: [
                    _TypingDots(colors: colors),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.contactName} sedang mengetik...',
                      style: TextStyle(
                          color: colors.muted,
                          fontSize: 11,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            _InputBar(
              controller: _inputC,
              focusNode: _focusNode,
              isDark: isDark,
              colors: colors,
              onSend: _sendMessage,
              onAttach: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lampiran (placeholder)'))),
            ),
          ],
        ),
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ── Header ────────────────────────────────────────────────────────────────────

class _ConvHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool isGroup;
  final int? memberCount;
  final bool isTyping;

  const _ConvHeader({
    required this.name,
    required this.avatarUrl,
    required this.isGroup,
    required this.memberCount,
    required this.isTyping,
  });

  Color _seed(String s) {
    final r = Random(s.hashCode);
    return Color.fromARGB(
        255, 120 + r.nextInt(80), 80 + r.nextInt(80), 140 + r.nextInt(80));
  }

  @override
  Widget build(BuildContext context) {
    final bg = _seed(name);
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.fromLTRB(4, 8, 12, 12),
      decoration: BoxDecoration(
        color: _kPurple,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
              color: _kPurple.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 40,
              height: 40,
              child: isGroup
                  ? Container(
                      color: Colors.white.withValues(alpha: 0.18),
                      child: const Icon(Icons.group,
                          color: Colors.white, size: 22))
                  : (avatarUrl != null
                      ? Image.network(avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              color: bg.withValues(alpha: 0.3),
                              alignment: Alignment.center,
                              child: Text(initial,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900))))
                      : Container(
                          color: bg.withValues(alpha: 0.3),
                          alignment: Alignment.center,
                          child: Text(initial,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900)))),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(
                  isTyping
                      ? 'Sedang mengetik...'
                      : isGroup
                          ? '${memberCount ?? 0} anggota'
                          : 'Online',
                  style: TextStyle(
                      color: isTyping
                          ? const Color(0xFFD8B4FE)
                          : Colors.white.withValues(alpha: 0.75),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          isTyping ? FontStyle.italic : FontStyle.normal),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined,
                color: Colors.white, size: 22),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video call (placeholder)'))),
          ),
          IconButton(
            icon:
                const Icon(Icons.call_outlined, color: Colors.white, size: 22),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice call (placeholder)'))),
          ),
        ],
      ),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final _Message msg;
  final double screenWidth;
  final AppColors colors;
  final bool isDark;

  const _MessageBubble({
    required this.msg,
    required this.screenWidth,
    required this.colors,
    required this.isDark,
  });

  String _fmt(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _showOptions(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('Salin pesan'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: msg.text));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pesan disalin')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.reply_outlined),
              title: const Text('Balas'),
              onTap: () => Navigator.pop(context),
            ),
            if (msg.isMe)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Hapus', style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMe = msg.isMe;
    final maxW = screenWidth * 0.72;
    final bubbleColor =
        isMe ? _kPurple : (isDark ? const Color(0xFF1E293B) : Colors.white);
    final textColor = isMe
        ? Colors.white
        : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF111827));
    final timeColor =
        isMe ? Colors.white.withValues(alpha: 0.65) : colors.muted;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _MiniAvatar(name: msg.isMe ? 'Me' : 'Other'),
            const SizedBox(width: 6),
          ],
          GestureDetector(
            onLongPress: () => _showOptions(context),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isMe ? 18 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(msg.text,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            height: 1.4)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_fmt(msg.time),
                            style: TextStyle(
                                color: timeColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            msg.isRead ? Icons.done_all : Icons.done,
                            size: 13,
                            color: msg.isRead
                                ? const Color(0xFF93C5FD)
                                : Colors.white.withValues(alpha: 0.6),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  final String name;
  const _MiniAvatar({required this.name});

  Color _seed(String s) {
    final r = Random(s.hashCode);
    return Color.fromARGB(
        255, 120 + r.nextInt(80), 80 + r.nextInt(80), 140 + r.nextInt(80));
  }

  @override
  Widget build(BuildContext context) {
    final bg = _seed(name);
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
          color: bg.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Text(initial,
          style:
              TextStyle(color: bg, fontSize: 12, fontWeight: FontWeight.w900)),
    );
  }
}

// ── Date divider ──────────────────────────────────────────────────────────────

class _DateDivider extends StatelessWidget {
  final DateTime date;
  const _DateDivider({required this.date});

  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Hari ini';
    if (d == today.subtract(const Duration(days: 1))) return 'Kemarin';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: const Color(0xFFF3E4FF),
                borderRadius: BorderRadius.circular(999)),
            child: Text(_label(),
                style: const TextStyle(
                    color: _kPurple,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

// ── Typing dots ───────────────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  final AppColors colors;
  const _TypingDots({required this.colors});

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final t = ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
          final scale = 0.6 + 0.4 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                    color: _kPurple.withValues(alpha: 0.6),
                    shape: BoxShape.circle),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Input bar ─────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDark;
  final AppColors colors;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.colors,
    required this.onSend,
    required this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.trim().isNotEmpty;
    final fillColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE8ECF4);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F7FB),
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _CircleBtn(
            icon: Icons.attach_file_rounded,
            color: colors.muted,
            bg: fillColor,
            border: borderColor,
            onTap: onAttach,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                    color: colors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ketik pesan...',
                  hintStyle: TextStyle(
                      color: colors.muted,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: hasText
                ? _CircleBtn(
                    key: const ValueKey('send'),
                    icon: Icons.send_rounded,
                    color: Colors.white,
                    bg: _kPurple,
                    border: _kPurple,
                    onTap: onSend,
                  )
                : _CircleBtn(
                    key: const ValueKey('mic'),
                    icon: Icons.mic_none_rounded,
                    color: colors.muted,
                    bg: fillColor,
                    border: borderColor,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Voice message (placeholder)'))),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final Color border;
  final VoidCallback onTap;

  const _CircleBtn({
    super.key,
    required this.icon,
    required this.color,
    required this.bg,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: border)),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
