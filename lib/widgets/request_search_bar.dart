import 'package:flutter/material.dart';

class RequestSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Color accent;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  const RequestSearchBar({
    super.key,
    required this.controller,
    required this.accent,
    required this.onChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: true,
                onChanged: onChanged,
                decoration: const InputDecoration(
                  hintText: 'Search by name, role, or company',
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 14.5),
              ),
            ),
            GestureDetector(
              onTap: onClose,
              child: Icon(Icons.close_rounded, color: Colors.grey.shade500, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
