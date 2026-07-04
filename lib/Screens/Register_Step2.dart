import 'package:devcollab/widgets/Step_progress_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/register2step_provider.dart';

class RegisterScreen2 extends StatelessWidget {
  const RegisterScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterProvider(),
      child: const _RegisterScreen2Content(),
    );
  }
}

class _RegisterScreen2Content extends StatelessWidget {
  const _RegisterScreen2Content();

  static const _bg = Colors.white;
  static const _surface = Color(0xFF1E1E2A);
  static const _border = Color(0xFF2E2E3E);
  static const _textPrimary = Colors.black;
  static const _textSecondary = Color(0xFF2B2B2C);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: StepProgressBar(currentStep: 2, totalSteps: 3),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What can you build?',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Pick all that apply · min 1',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _sectionLabel('SKILLS'),
                    const SizedBox(height: 12),
                    _buildSkillsWrap(context, provider),

                    const SizedBox(height: 28),

                    _sectionLabel('EXPERIENCE LEVEL'),
                    const SizedBox(height: 12),
                    _buildSingleSelectRow(
                      options: provider.experienceLevels,
                      selected: provider.experience,
                      onSelect: (v) => provider.selectExperience(v),
                    ),

                    const SizedBox(height: 28),

                    _sectionLabel('OPEN TO'),
                    const SizedBox(height: 12),
                    _buildMultiSelectWrap(
                      options: provider.openToOptions,
                      selected: provider.openTo,
                      onToggle: (v) => provider.toggleOpenTo(v),
                    ),

                    const SizedBox(height: 28),

                    _sectionLabel('AVAILABILITY'),
                    const SizedBox(height: 12),
                    _buildSingleSelectRow(
                      options: provider.availabilityOptions,
                      selected: provider.availability,
                      onSelect: (v) => provider.selectAvailability(v),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            _buildContinueButton(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSkillsWrap(BuildContext context, RegisterProvider provider) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...provider.allSkills.map((skill) {  // Note: _allSkills is private, you can expose a getter if you prefer
          final isSelected = provider.selectedSkills.contains(skill);
          return _chip(
            label: skill,
            selected: isSelected,
            onTap: () => provider.toggleSkill(skill),
          );
        }),
        // Add button
        GestureDetector(
          onTap: () => _showAddSkillDialog(context, provider),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _border),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, size: 15, color: _textSecondary),
                SizedBox(width: 4),
                Text('Add',
                    style: TextStyle(
                        color: _textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleSelectRow({
    required List<String> options,
    required String selected,
    required Function(String) onSelect,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((o) {
        final isSel = o == selected;
        return _chip(label: o, selected: isSel, onTap: () => onSelect(o));
      }).toList(),
    );
  }

  Widget _buildMultiSelectWrap({
    required List<String> options,
    required List<String> selected,
    required Function(String) onToggle,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((o) {
        return _chip(
          label: o,
          selected: selected.contains(o),
          onTap: () => onToggle(o),
        );
      }).toList(),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? RegisterProvider.purple : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? RegisterProvider.purple : _border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : _textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check_rounded, size: 13, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, RegisterProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      decoration: BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _border.withOpacity(0.5))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: AnimatedOpacity(
          opacity: provider.canContinue ? 1.0 : 0.4,
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: provider.isLoading
                ? null
                : () async {
              final success = await provider.register();
              if (success) {
                Navigator.pushNamed(context, '/register3');
              } else if (provider.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(provider.errorMessage!)),
                );
              }
            },
            child: provider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Continue'),
          )
        ),
      ),
    );
  }

  void _showAddSkillDialog(BuildContext context, RegisterProvider provider) {
    final controller = TextEditingController();
    String? errorText;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
      pageBuilder: (context, _, __) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header (same as before)
                      Container(
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [RegisterProvider.purple.withOpacity(0.18), _surface],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: RegisterProvider.purple.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: const Icon(Icons.auto_awesome_rounded, size: 18, color: RegisterProvider.purple),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Add a Skill', style: TextStyle(color: _bg, fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
                                SizedBox(height: 2),
                                Text('Appears on your profile', style: TextStyle(color: _bg, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 4, 22, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: controller,
                              autofocus: true,
                              style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                hintText: 'e.g. Next.js, Figma, Python…',
                                hintStyle: const TextStyle(color: _textSecondary),
                                errorText: errorText,
                                prefixIcon: const Icon(Icons.code_rounded, size: 15, color: _textSecondary),
                                filled: true,
                                fillColor: _bg,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _border)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _border)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: RegisterProvider.purple, width: 1.5)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                              ),
                              onChanged: (_) {
                                if (errorText != null) setDialogState(() => errorText = null);
                              },
                              onSubmitted: (_) => _handleAdd(controller, setDialogState,context, provider, (e) => errorText = e),
                            ),

                            // Preview chip (same as before)
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              child: ValueListenableBuilder(
                                valueListenable: controller,
                                builder: (_, value, __) {
                                  final text = value.text.trim();
                                  if (text.isEmpty) return const SizedBox.shrink();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('PREVIEW', style: TextStyle(color: _bg, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          decoration: BoxDecoration(color: RegisterProvider.purple, borderRadius: BorderRadius.circular(20)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                                              const SizedBox(width: 6),
                                              const Icon(Icons.check_rounded, size: 13, color: Colors.white),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  backgroundColor: _bg,
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: _bg)),
                                ),
                                child: const Text('Cancel', style: TextStyle(color: _textSecondary)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: () => _handleAdd(controller, setDialogState, context,provider, (e) => errorText = e),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: RegisterProvider.purple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.add_rounded, size: 16),
                                label: const Text('Add Skill', style: TextStyle(fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _handleAdd(
      TextEditingController controller,
      StateSetter setDialogState,
      BuildContext context,
      RegisterProvider provider,
      void Function(String?) setError,
      ) {
    final newSkill = controller.text.trim();
    if (newSkill.isEmpty) {
      setDialogState(() => setError('Please enter a skill name'));
      return;
    }
    if (provider.selectedSkills.contains(newSkill)) {
      setDialogState(() => setError("You've already added this skill"));
      return;
    }

    provider.addNewSkill(newSkill);
    Navigator.pop(context);
  }
}