import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/Reqest_model.dart';
import 'avatar_widget.dart';
import 'status_chip.dart';
import 'request_actions.dart';

class RequestCard extends StatefulWidget {
  final RequestModel request;
  final bool isReceived;
  final Color accent;
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onTap;
  final VoidCallback onViewProfile;
  final VoidCallback onReport;
  final VoidCallback onBlock;

  const RequestCard({
    super.key,
    required this.request,
    required this.isReceived,
    required this.accent,
    required this.onAccept,
    required this.onReject,
    required this.onTap,
    required this.onViewProfile,
    required this.onReport,
    required this.onBlock,
    this.isLoading = false,
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

enum _SwipeAction { none, accept, reject }

class _RequestCardState extends State<RequestCard> with SingleTickerProviderStateMixin {
  double _dragX = 0;
  _SwipeAction _pendingAction = _SwipeAction.none;
  static const double _threshold = 96;

  void _onDragUpdate(DragUpdateDetails d) {
    if (!widget.isReceived) return;
    setState(() {
      _dragX += d.delta.dx;
      _dragX = _dragX.clamp(-140.0, 140.0);
    });
  }

  void _onDragEnd(DragEndDetails d) {
    if (!widget.isReceived) return;
    if (_dragX > _threshold) {
      setState(() => _pendingAction = _SwipeAction.accept);
      widget.onAccept();
    } else if (_dragX < -_threshold) {
      setState(() => _pendingAction = _SwipeAction.reject);
      widget.onReject();
    }
    setState(() => _dragX = 0);
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgOverlay = _dragX > 0
        ? const Color(0xFF22C55E).withOpacity((_dragX / _threshold).clamp(0, 1) * 0.18)
        : _dragX < 0
            ? const Color(0xFFEF4444).withOpacity((-_dragX / _threshold).clamp(0, 1) * 0.18)
            : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: Stack(
        children: [
          if (widget.isReceived)
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 24),
                      child: Icon(Icons.check_circle_rounded,
                          color: const Color(0xFF22C55E)
                              .withOpacity((_dragX / _threshold).clamp(0, 1)),
                          size: 30),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      child: Icon(Icons.cancel_rounded,
                          color: const Color(0xFFEF4444)
                              .withOpacity((-_dragX / _threshold).clamp(0, 1)),
                          size: 30),
                    ),
                  ),
                ],
              ),
            ),
          GestureDetector(
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              transform: Matrix4.translationValues(_dragX, 0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgOverlay == Colors.transparent
                          ? (isDark
                              ? Colors.white.withOpacity(0.045)
                              : Colors.white.withOpacity(0.75))
                          : Color.alphaBlend(
                              bgOverlay,
                              isDark
                                  ? Colors.white.withOpacity(0.045)
                                  : Colors.white.withOpacity(0.75)),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.white.withOpacity(0.6),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.35 : 0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AvatarWidget(
                              heroTag: 'avatar-${r.id}',
                              name: r.name,
                              avatarUrl: r.avatarUrl,
                              isOnline: r.isOnline,
                              isVerified: r.isVerified,
                              accent: widget.accent,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          r.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800, fontSize: 16.5),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        timeago.format(r.createdAt, allowFromNow: true),
                                        style: TextStyle(
                                            color: Colors.grey.shade500, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    r.company != null && r.company!.isNotEmpty
                                        ? '${r.role} · ${r.company}'
                                        : r.role,
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (r.mutualConnections > 0) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      '${r.mutualConnections} mutual connection${r.mutualConnections == 1 ? '' : 's'}',
                                      style: TextStyle(
                                          color: widget.accent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (!widget.isReceived) StatusChip(status: r.status),
                          ],
                        ),
                        if (r.message != null && r.message!.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                            decoration: BoxDecoration(
                              color: widget.accent.withOpacity(0.06),
                              border: Border.all(color: widget.accent.withOpacity(0.14)),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              '"${r.message}"',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                        if (r.skills.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: r.skills.take(5).map((s) => _SkillChip(s, widget.accent)).toList(),
                          ),
                        ],
                        if (widget.isReceived) ...[
                          const SizedBox(height: 16),
                          Divider(color: Colors.grey.withOpacity(0.15), height: 1),
                          const SizedBox(height: 14),
                          RequestActions(
                            accent: widget.accent,
                            isLoading: widget.isLoading,
                            onAccept: widget.onAccept,
                            onReject: widget.onReject,
                            onViewProfile: widget.onViewProfile,
                            onReport: widget.onReport,
                            onBlock: widget.onBlock,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final Color accent;
  const _SkillChip(this.label, this.accent);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: accent),
      ),
    );
  }
}
