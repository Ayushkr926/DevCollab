import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SegmentedTabBar extends StatelessWidget {
  final int currentIndex;
  final int unreadCount;
  final Color accent;
  final ValueChanged<int> onChanged;

  const SegmentedTabBar({
    super.key,
    required this.currentIndex,
    required this.unreadCount,
    required this.accent,
    required this.onChanged,
  });

  static const _labels = ['Received', 'Sent'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = constraints.maxWidth / 2;
          return Container(
            height: 52,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  left: currentIndex * segmentWidth,
                  top: 0,
                  bottom: 0,
                  width: segmentWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [accent, accent.withOpacity(0.75)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: List.generate(2, (i) {
                    final selected = currentIndex == i;
                    final showBadge = i == 0 && unreadCount > 0;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (currentIndex != i) {
                            HapticFeedback.selectionClick();
                            onChanged(i);
                          }
                        },
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 250),
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : (isDark ? Colors.white70 : Colors.black87),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                                child: Text(_labels[i]),
                              ),
                              if (showBadge) ...[
                                const SizedBox(width: 6),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.white
                                        : accent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$unreadCount',
                                    style: TextStyle(
                                      color: selected ? accent : accent,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
