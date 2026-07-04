import 'package:flutter/material.dart';
import '../../providers/request_provider.dart';

class FilterBottomSheet extends StatelessWidget {
  final RequestFilter currentFilter;
  final RequestSort currentSort;
  final Color accent;
  final ValueChanged<RequestFilter> onFilterChanged;
  final ValueChanged<RequestSort> onSortChanged;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.currentSort,
    required this.accent,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required RequestFilter currentFilter,
    required RequestSort currentSort,
    required Color accent,
    required ValueChanged<RequestFilter> onFilterChanged,
    required ValueChanged<RequestSort> onSortChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        currentFilter: currentFilter,
        currentSort: currentSort,
        accent: accent,
        onFilterChanged: onFilterChanged,
        onSortChanged: onSortChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C22) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 20),
          const Text('Filter Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: RequestFilter.values.map((f) {
              final selected = f == currentFilter;
              return _Pill(
                label: _filterLabel(f),
                selected: selected,
                accent: accent,
                onTap: () => onFilterChanged(f),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          const Text('Sort By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            children: RequestSort.values.map((s) {
              final selected = s == currentSort;
              return _Pill(
                label: s == RequestSort.newest ? 'Newest' : 'Oldest',
                selected: selected,
                accent: accent,
                onTap: () => onSortChanged(s),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _filterLabel(RequestFilter f) {
    switch (f) {
      case RequestFilter.all:
        return 'All';
      case RequestFilter.unread:
        return 'Unread';
      case RequestFilter.pending:
        return 'Pending';
      case RequestFilter.accepted:
        return 'Accepted';
      case RequestFilter.rejected:
        return 'Rejected';
    }
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;
  const _Pill({required this.label, required this.selected, required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? accent : accent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : accent,
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
