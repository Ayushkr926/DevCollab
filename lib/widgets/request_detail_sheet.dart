import 'package:flutter/material.dart';
import '../../models/Reqest_model.dart';
import 'avatar_widget.dart';
import 'status_chip.dart';

class RequestDetailSheet extends StatelessWidget {
  final RequestModel request;
  final bool isReceived;
  final Color accent;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const RequestDetailSheet({
    super.key,
    required this.request,
    required this.isReceived,
    required this.accent,
    required this.onAccept,
    required this.onReject,
  });

  static Future<void> show(
    BuildContext context, {
    required RequestModel request,
    required bool isReceived,
    required Color accent,
    required VoidCallback onAccept,
    required VoidCallback onReject,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RequestDetailSheet(
        request: request,
        isReceived: isReceived,
        accent: accent,
        onAccept: onAccept,
        onReject: onReject,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C22) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scrollCtrl,
            padding: EdgeInsets.fromLTRB(
                20, 12, 20, MediaQuery.of(context).padding.bottom + 24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  AvatarWidget(
                    heroTag: 'avatar-${request.id}-detail',
                    name: request.name,
                    avatarUrl: request.avatarUrl,
                    isOnline: request.isOnline,
                    isVerified: request.isVerified,
                    accent: accent,
                    size: 76,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request.name,
                            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          request.company != null && request.company!.isNotEmpty
                              ? '${request.role} at ${request.company}'
                              : request.role,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13.5),
                        ),
                        const SizedBox(height: 8),
                        if (!isReceived) StatusChip(status: request.status),
                      ],
                    ),
                  ),
                ],
              ),
              if (request.mutualConnections > 0) ...[
                const SizedBox(height: 18),
                _SectionLabel('Mutual Connections'),
                const SizedBox(height: 8),
                Text('${request.mutualConnections} people you both know',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13.5)),
              ],
              if (request.message != null && request.message!.isNotEmpty) ...[
                const SizedBox(height: 20),
                _SectionLabel('Message'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text('"${request.message}"',
                      style: TextStyle(
                          fontSize: 14, height: 1.5,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade800)),
                ),
              ],
              if (request.skills.isNotEmpty) ...[
                const SizedBox(height: 20),
                _SectionLabel('Skills'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: request.skills
                      .map((s) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: accent.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(s,
                                style: TextStyle(
                                    color: accent, fontWeight: FontWeight.w600, fontSize: 12.5)),
                          ))
                      .toList(),
                ),
              ],
              if (isReceived) ...[
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onReject();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Decline', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onAccept();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Text('Accept', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: Colors.grey.shade500));
  }
}
