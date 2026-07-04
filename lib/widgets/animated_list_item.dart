import 'package:flutter/material.dart';

/// Staggered entrance animation (fade + slide + scale) for list items.
class AnimatedListItem extends StatelessWidget {
  final int index;
  final Widget child;
  const AnimatedListItem({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + (index.clamp(0, 8) * 60)),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) {
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * 24),
            child: Transform.scale(
              scale: 0.94 + (0.06 * v),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

/// Exit animation used right before a card is removed from the list:
/// - `accept`: card shrinks and shows a green check
/// - `reject`: card shakes then fades away
class RequestExitAnimation extends StatefulWidget {
  final bool isAccept;
  final Widget child;
  final VoidCallback onCompleted;

  const RequestExitAnimation({
    super.key,
    required this.isAccept,
    required this.child,
    required this.onCompleted,
  });

  @override
  State<RequestExitAnimation> createState() => _RequestExitAnimationState();
}

class _RequestExitAnimationState extends State<RequestExitAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..forward();
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onCompleted();
    });
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
      builder: (context, child) {
        final t = _ctrl.value;
        if (widget.isAccept) {
          final scale = 1 - (t * 0.25);
          return Opacity(
            opacity: (1 - t).clamp(0, 1),
            child: Transform.scale(
              scale: scale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  child!,
                  if (t > 0.15)
                    Opacity(
                      opacity: (t * 1.6).clamp(0, 1),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 32),
                      ),
                    ),
                ],
              ),
            ),
          );
        } else {
          final shake = t < 0.35 ? (12 * (0.35 - t) * ((t * 40).floor().isEven ? 1 : -1)) : 0.0;
          final fadeT = t < 0.35 ? 1.0 : 1 - ((t - 0.35) / 0.65);
          return Opacity(
            opacity: fadeT.clamp(0, 1),
            child: Transform.translate(
              offset: Offset(shake, 0),
              child: child,
            ),
          );
        }
      },
      child: widget.child,
    );
  }
}
