import 'package:flutter/material.dart';

const kPurple = Color(0xFF6B257F);
const kSoftBg = Color(0xFFF8F8FA);
const kBorder = Color(0xFFEDF1F7);
const kHint = Color(0xFF8F9BB3);
const kSave = Color(0xFFA98B98);

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final eventNameCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final startCtrl = TextEditingController();
  final endCtrl = TextEditingController();

  bool repeatWeekly = true;
  bool onlineMeeting = false;
  bool notify30 = true;

  Color selectedColor = const Color(0xFF89AFFF);

  @override
  void dispose() {
    eventNameCtrl.dispose();
    noteCtrl.dispose();
    dateCtrl.dispose();
    startCtrl.dispose();
    endCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        dateCtrl.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _pickTime(TextEditingController ctrl) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) {
      setState(() => ctrl.text = t.format(context));
    }
  }

  void _save() {
    // TODO: simpan data meeting (nanti bisa return data ke jadwal_buat)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR (X - Add Meeting - Save)
            Container(
              color: kSoftBg,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  _TopCircleButton(
                    icon: Icons.close,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Add Meeting',
                        style: TextStyle(
                          color: Color(0xFF1B1B1B),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 90,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSave,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: _save,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // FORM
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    _TextFieldBox(
                      controller: eventNameCtrl,
                      hint: 'Event name*',
                      maxLines: 1,
                    ),
                    const SizedBox(height: 14),
                    _TextFieldBox(
                      controller: noteCtrl,
                      hint: 'Type the note here...',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 14),

                    // Date
                    _TapField(
                      hint: 'Date',
                      value: dateCtrl.text.isEmpty ? null : dateCtrl.text,
                      icon: Icons.calendar_month_outlined,
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 14),

                    // Start / End time
                    Row(
                      children: [
                        Expanded(
                          child: _TapField(
                            hint: 'Start time',
                            value: startCtrl.text.isEmpty
                                ? null
                                : startCtrl.text,
                            icon: Icons.access_time,
                            onTap: () => _pickTime(startCtrl),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _TapField(
                            hint: 'End time',
                            value: endCtrl.text.isEmpty ? null : endCtrl.text,
                            icon: Icons.access_time,
                            onTap: () => _pickTime(endCtrl),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Timezone
                    _RowItem(
                      icon: Icons.public,
                      title: 'Select a time zone',
                      onTap: () {
                        // TODO: pilih timezone
                      },
                    ),
                    const SizedBox(height: 12),

                    // Repeat weekly
                    _SwitchRow(
                      icon: Icons.repeat,
                      title: 'Repeat Every week',
                      value: repeatWeekly,
                      onChanged: (v) => setState(() => repeatWeekly = v),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 12),

                    // Add people
                    _RowItem(
                      icon: Icons.person_add_alt_1,
                      title: '+ Add people',
                      onTap: () {
                        // TODO: add people
                      },
                    ),
                    const SizedBox(height: 12),

                    // Online meeting
                    _SwitchRow(
                      icon: Icons.videocam_outlined,
                      title: 'Online meeting',
                      value: onlineMeeting,
                      onChanged: (v) => setState(() => onlineMeeting = v),
                    ),
                    const SizedBox(height: 12),

                    // Add location
                    _RowItem(
                      icon: Icons.location_on_outlined,
                      title: '+ Add location',
                      onTap: () {
                        // TODO: add location
                      },
                    ),
                    const SizedBox(height: 12),

                    // Notify
                    _SwitchRow(
                      icon: Icons.notifications_none,
                      title: 'Notify me 30 min before meeting',
                      value: notify30,
                      onChanged: (v) => setState(() => notify30 = v),
                    ),
                    const SizedBox(height: 12),

                    // Color
                    _ColorRow(
                      color: selectedColor,
                      onTap: () {
                        // TODO: pilih warna (contoh cycle cepat)
                        setState(() {
                          selectedColor =
                              selectedColor == const Color(0xFF89AFFF)
                              ? const Color(0xFF26BFBF)
                              : const Color(0xFF89AFFF);
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Attachment
                    _RowItem(
                      icon: Icons.attach_file,
                      title: 'Add attachment',
                      onTap: () {
                        // TODO: attachment
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _TopCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF1B1B1B), size: 22),
      ),
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _TextFieldBox({
    required this.controller,
    required this.hint,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: Color(0xFF1B1B1B),
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: kHint,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _TapField extends StatelessWidget {
  final String hint;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;

  const _TapField({
    required this.hint,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: kBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  color: value == null ? kHint : const Color(0xFF1B1B1B),
                  fontSize: 14,
                ),
              ),
            ),
            Icon(icon, size: 18, color: kHint),
          ],
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _RowItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: kHint),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: kHint,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: kHint),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: kHint,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: kPurple),
        ],
      ),
    );
  }
}

class _ColorRow extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _ColorRow({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            const Text(
              'Select a color ',
              style: TextStyle(
                color: kHint,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
            const Text(
              '(default color)',
              style: TextStyle(
                color: Color(0x998F9BB3),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.67,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
