import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Rounded pill search bar with an animated focus glow, a leading
/// search icon, and a trailing filter icon button.
class PremiumSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final bool filtersActive;

  const PremiumSearchBar({
    super.key,
    required this.onChanged,
    required this.onFilterTap,
    this.filtersActive = false,
  });

  @override
  State<PremiumSearchBar> createState() => _PremiumSearchBarState();
}

class _PremiumSearchBarState extends State<PremiumSearchBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: _focused
              ? AppColors.brandPrimary.withOpacity(0.55)
              : const Color(0xFFEFEFF3),
          width: _focused ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _focused
                ? AppColors.brandPrimary.withOpacity(0.16)
                : AppColors.softShadow,
            blurRadius: _focused ? 22 : 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 54,
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(Icons.search_rounded,
              size: 21,
              color: _focused ? AppColors.brandPrimary : AppColors.textTertiary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w500),
              cursorColor: AppColors.brandPrimary,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: 'Search by name…',
                hintStyle: AppTextStyles.searchHint,
              ),
            ),
          ),
          _FilterButton(active: widget.filtersActive, onTap: widget.onFilterTap),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _FilterButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: active
              ? const LinearGradient(colors: AppColors.brandGradient)
              : null,
          color: active ? null : const Color(0xFFF4F4F7),
        ),
        child: Icon(
          Icons.tune_rounded,
          size: 19,
          color: active ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}
