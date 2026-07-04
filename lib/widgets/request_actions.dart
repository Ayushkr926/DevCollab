import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RequestActions extends StatefulWidget {
  final Color accent;
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onViewProfile;
  final VoidCallback onReport;
  final VoidCallback onBlock;

  const RequestActions({
    super.key,
    required this.accent,
    required this.onAccept,
    required this.onReject,
    required this.onViewProfile,
    required this.onReport,
    required this.onBlock,
    this.isLoading = false,
  });

  @override
  State<RequestActions> createState() => _RequestActionsState();
}

class _RequestActionsState extends State<RequestActions> {
  void _openMenu(BuildContext context) {
    HapticFeedback.lightImpact();
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 100, 16, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: [
        PopupMenuItem(
          onTap: widget.onViewProfile,
          child: const Row(children: [
            Icon(Icons.person_outline_rounded, size: 18),
            SizedBox(width: 10),
            Text('View Profile'),
          ]),
        ),
        PopupMenuItem(
          onTap: widget.onReport,
          child: const Row(children: [
            Icon(Icons.flag_outlined, size: 18),
            SizedBox(width: 10),
            Text('Report'),
          ]),
        ),
        PopupMenuItem(
          onTap: widget.onBlock,
          child: const Row(children: [
            Icon(Icons.block_outlined, size: 18, color: Colors.red),
            SizedBox(width: 10),
            Text('Block', style: TextStyle(color: Colors.red)),
          ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MoreButton(onTap: () => _openMenu(context)),
        const SizedBox(width: 10),
        Expanded(
          child: _PressableButton(
            onTap: () {
              HapticFeedback.mediumImpact();
              widget.onReject();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withOpacity(0.5), width: 1.4),
              ),
              alignment: Alignment.center,
              child: const Text('Decline',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w700, fontSize: 14.5)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: _PressableButton(
            onTap: widget.isLoading
                ? () {}
                : () {
                    HapticFeedback.mediumImpact();
                    widget.onAccept();
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: widget.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_rounded, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text('Accept',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5)),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const _MoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _PressableButton(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.06)
              : Colors.grey.shade100,
        ),
        child: const Icon(Icons.more_horiz_rounded, size: 20),
      ),
    );
  }
}

class _PressableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PressableButton({required this.child, required this.onTap});

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _scale = 0.94),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
