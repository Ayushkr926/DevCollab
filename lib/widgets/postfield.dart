// lib/widgets/project/post_project_widgets.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Animated form field with floating label, char count, error state
// ─────────────────────────────────────────────────────────────────────────────
class PpField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool required;
  final int maxLength;
  final int maxLines;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const PpField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.required = true,
    this.maxLength = 100,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
  });

  @override
  State<PpField> createState() => _PpFieldState();
}

class _PpFieldState extends State<PpField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color get _borderColor {
    if (widget.errorText != null) return DC.r;
    if (_focused) return DC.p;
    if (widget.controller.text.isNotEmpty) return DC.g;
    return DC.border;
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.controller.text.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.required)
                Container(
                  width: 4, height: 4,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(color: DC.r, shape: BoxShape.circle),
                ),
              Text(
                widget.label.toUpperCase(),
                style: DCText.label.copyWith(
                  color: widget.errorText != null
                      ? DC.r
                      : _focused ? DC.p : DC.textSecondary,
                ),
              ),
              if (!widget.required) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(color: DC.a2, borderRadius: BorderRadius.circular(4)),
                  child: Text('optional', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: DC.a3)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            decoration: BoxDecoration(
              color: widget.errorText != null
                  ? const Color(0xFFFCEBEB)
                  : _focused ? DC.p3.withOpacity(.3) : Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: _borderColor, width: _focused ? 1.4 : .5),
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              style: DCText.body.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(fontSize: 13, color: DC.textTertiary, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                prefixIcon: widget.maxLines == 1
                    ? Padding(
                  padding: const EdgeInsets.only(left: 12, right: 6),
                  child: Icon(widget.prefixIcon, size: 16,
                      color: _focused ? DC.p : DC.textTertiary),
                )
                    : null,
                prefixIconConstraints: const BoxConstraints(minWidth: 38),
                suffixIcon: widget.controller.text.isNotEmpty && widget.errorText == null && widget.maxLines == 1
                    ? const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.check_circle_rounded, size: 16, color: DC.g),
                )
                    : null,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.errorText != null)
                Row(
                  children: [
                    const Icon(Icons.cancel_rounded, size: 11, color: DC.r),
                    const SizedBox(width: 4),
                    Text(widget.errorText!, style: const TextStyle(fontSize: 10, color: DC.r, fontWeight: FontWeight.w600)),
                  ],
                )
              else
                const SizedBox(),
              if (widget.maxLines > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text('$count / ${widget.maxLength}', style: DCText.micro),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section label with required dot / optional badge
// ─────────────────────────────────────────────────────────────────────────────
class PpSectionLabel extends StatelessWidget {
  final String title;
  final bool required;
  final String? errorText;

  const PpSectionLabel({super.key, required this.title, this.required = true, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          if (required)
            Container(width: 4, height: 4, margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(color: DC.r, shape: BoxShape.circle)),
          Text(title.toUpperCase(), style: DCText.label.copyWith(
              color: errorText != null ? DC.r : DC.textSecondary)),
          if (!required) ...[
            const SizedBox(width: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(color: DC.a2, borderRadius: BorderRadius.circular(4)),
                child: Text('optional', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: DC.a3))),
          ],
          if (errorText != null) ...[
            const Spacer(),
            Text(errorText!, style: const TextStyle(fontSize: 10, color: DC.r, fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated selectable chip — used for skills, types, categories
// ─────────────────────────────────────────────────────────────────────────────
class PpChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const PpChip({super.key, required this.label, required this.selected, required this.onTap, this.icon});

  @override
  State<PpChip> createState() => _PpChipState();
}

class _PpChipState extends State<PpChip> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 110));
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); HapticFeedback.selectionClick(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: widget.selected ? DC.p : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.selected ? DC.p : DC.border, width: widget.selected ? 0 : .5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 12, color: widget.selected ? Colors.white : DC.textSecondary),
                const SizedBox(width: 5),
              ],
              Text(widget.label, style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700,
                color: widget.selected ? Colors.white : DC.textSecondary,
              )),
              if (widget.selected) ...[
                const SizedBox(width: 4),
                const Icon(Icons.check_rounded, size: 12, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single-select segmented control (experience, duration, work style)
// ─────────────────────────────────────────────────────────────────────────────
class PpSegment extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;

  const PpSegment({super.key, required this.options, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: DC.bg2, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: options.map((opt) {
          final isSel = selected == opt;
          return Expanded(
            child: GestureDetector(
              onTap: () { HapticFeedback.selectionClick(); onSelect(opt); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSel ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isSel ? [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 4)] : null,
                ),
                child: Text(opt, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                        color: isSel ? DC.p : DC.textSecondary)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Role chip with delete + the input row to add new roles
// ─────────────────────────────────────────────────────────────────────────────
class PpRoleRow extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;

  const PpRoleRow({super.key, required this.label, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset((1 - v) * -12, 0), child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 7),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: DC.bg2, borderRadius: BorderRadius.circular(11)),
        child: Row(
          children: [
            Container(
              width: 7, height: 7,
              decoration: const BoxDecoration(color: DC.p, shape: BoxShape.circle),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: DC.textPrimary)),
            ),
            GestureDetector(
              onTap: () { HapticFeedback.lightImpact(); onDelete(); },
              child: Container(
                width: 22, height: 22,
                decoration: BoxDecoration(color: const Color(0xFFFCEBEB), borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.close_rounded, size: 13, color: DC.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PpRoleInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onAdd;

  const PpRoleInput({super.key, required this.controller, required this.focusNode, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: DC.border, width: .5, style: BorderStyle.solid),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onSubmitted: (_) => onAdd(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                hintText: 'e.g. Flutter developer',
                hintStyle: TextStyle(fontSize: 12, color: DC.textTertiary, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: DC.p, borderRadius: BorderRadius.circular(11)),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step progress header — 3 dots/bars with labels
// ─────────────────────────────────────────────────────────────────────────────
class PpStepHeader extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int>? onStepTap;

  const PpStepHeader({super.key, required this.currentStep, this.onStepTap});

  static const _labels = ['Basics', 'Requirements', 'Logistics'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Column(
        children: [
          Row(
            children: List.generate(3, (i) {
              final isDone = i < currentStep;
              final isActive = i == currentStep;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onStepTap?.call(i),
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDone || isActive ? DC.p : DC.bg2,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (i) {
              final isActive = i == currentStep;
              return Text(
                _labels[i],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                  color: isActive ? DC.p : DC.textTertiary,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class PpCompletionBadge extends StatelessWidget {
  final int percent;
  const PpCompletionBadge({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: DC.p3,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFAFA9EC), width: .5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28, height: 28,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: percent / 100),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, v, _) => SizedBox(
                    width: 28, height: 28,
                    child: CircularProgressIndicator(
                      value: v,
                      strokeWidth: 2.5,
                      backgroundColor: const Color(0xFFD8D4F5),
                      valueColor: const AlwaysStoppedAnimation(DC.p),
                    ),
                  ),
                ),
                Text('$percent', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: DC.p)),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Text('Draft complete', style: DCText.micro.copyWith(color: DC.p, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom action bar — Back / Continue / Post buttons
// ─────────────────────────────────────────────────────────────────────────────
class PpBottomBar extends StatelessWidget {
  final bool showBack;
  final String primaryLabel;
  final bool isLoading;
  final VoidCallback onPrimary;
  final VoidCallback? onBack;

  const PpBottomBar({
    super.key,
    required this.showBack,
    required this.primaryLabel,
    required this.onPrimary,
    this.isLoading = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: DC.borderLight, width: .5)),
      ),
      child: Row(
        children: [
          if (showBack) ...[
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: DC.border, width: .5),
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 18, color: DC.textSecondary),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: GestureDetector(
              onTap: isLoading ? null : onPrimary,
              child: Container(
                height: 48,
                decoration: BoxDecoration(color: DC.p, borderRadius: BorderRadius.circular(13)),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2.2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                  )
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(primaryLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded, size: 15, color: Colors.white),
                    ],
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