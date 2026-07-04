import 'package:flutter/material.dart';

class StatsHeader extends StatelessWidget {
  final int incoming;
  final int pending;
  final int acceptedToday;
  final int unread;

  const StatsHeader({
    super.key,
    required this.incoming,
    required this.pending,
    required this.acceptedToday,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatData('Incoming', incoming, Icons.people_alt_rounded,
          const [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
      _StatData('Pending', pending, Icons.schedule_rounded,
          const [Color(0xFFF59E0B), Color(0xFFFB923C)]),
      _StatData('Accepted Today', acceptedToday, Icons.check_circle_rounded,
          const [Color(0xFF22C55E), Color(0xFF16A34A)]),
      _StatData('Unread', unread, Icons.mark_email_unread_rounded,
          const [Color(0xFFEC4899), Color(0xFFF472B6)]),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.65,
      ),
      itemBuilder: (context, i) {
        final item = items[i];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + i * 90),
          curve: Curves.easeOutCubic,
          builder: (context, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(
              offset: Offset(0, (1 - v) * 14),
              child: child,
            ),
          ),
          child: _StatCard(item),
        );
      },
    );
  }
}

class _StatData {
  final String label;
  final int value;
  final IconData icon;
  final List<Color> gradient;
  _StatData(this.label, this.value, this.icon, this.gradient);
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  const _StatCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: data.gradient.first.withOpacity(0.32),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(data.icon, color: Colors.white, size: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: data.value),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) => Text(
                  '$v',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          Text(
            data.label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
