import 'package:devcollab/widgets/Step_progress_widgets.dart';
import 'package:flutter/material.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2({super.key});

  @override
  State<RegisterScreen2> createState() => _RegisterScreen2State();
}

class _RegisterScreen2State extends State<RegisterScreen2> {
  // ── Skills ────────────────────────────
  final List<String> _allSkills = [
    'Flutter', 'Node.js', 'React', 'Vue.js',
    'MongoDB', 'Python', 'Swift', 'Kotlin',
    'Figma', 'Firebase', 'Docker', 'AWS',
    'ML/AI', 'GraphQL', 'Go',
  ];
  List<String> _selectedSkills = [];

  // ── Experience ────────────────────────
  String _experience = 'Junior';
  final _experienceLevels = ['Student', 'Junior', 'Mid', 'Senior', 'Lead'];

  // ── Open To ───────────────────────────
  List<String> _openTo = ['Hackathons', 'Freelance'];
  final _openToOptions = ['Hackathons', 'Freelance', 'Full-time', 'Open source'];

  // ── Availability ──────────────────────
  String _availability = 'Available';
  final _availabilityOptions = ['Available', 'Part-time', 'Busy'];

  static const _purple = Color(0xFF6C63FF);
  static const _bg = Colors.white;
  static const _surface = Color(0xFF1E1E2A);
  static const _border = Color(0xFF2E2E3E);
  static const _textPrimary = Colors.black;
  static const _textSecondary = Color(0xFF2B2B2C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: StepProgressBar(currentStep: 2, totalSteps: 3),
            ),

            // ── Scrollable content ────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
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

                    // ── SKILLS ──────────────────────────────
                    _sectionLabel('SKILLS'),
                    const SizedBox(height: 12),
                    _buildSkillsWrap(),

                    const SizedBox(height: 28),

                    // ── EXPERIENCE LEVEL ────────────────────
                    _sectionLabel('EXPERIENCE LEVEL'),
                    const SizedBox(height: 12),
                    _buildSingleSelectRow(
                      options: _experienceLevels,
                      selected: _experience,
                      onSelect: (v) => setState(() => _experience = v),
                    ),

                    const SizedBox(height: 28),

                    // ── OPEN TO ─────────────────────────────
                    _sectionLabel('OPEN TO'),
                    const SizedBox(height: 12),
                    _buildMultiSelectWrap(
                      options: _openToOptions,
                      selected: _openTo,
                      onToggle: (v) {
                        setState(() {
                          _openTo.contains(v)
                              ? _openTo.remove(v)
                              : _openTo.add(v);
                        });
                      },
                    ),

                    const SizedBox(height: 28),

                    // ── AVAILABILITY ────────────────────────
                    _sectionLabel('AVAILABILITY'),
                    const SizedBox(height: 12),
                    _buildSingleSelectRow(
                      options: _availabilityOptions,
                      selected: _availability,
                      onSelect: (v) => setState(() => _availability = v),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Continue button ───────────────────────
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  // ── Progress bar (3 segments) ─────────────────────────────────────────────
  Widget _buildProgressBar() {
    return Row(
      children: List.generate(3, (i) {
        final filled = i < 2;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: filled ? _purple : _border,
            ),
          ),
        );
      }),
    );
  }

  // ── Section label ─────────────────────────────────────────────────────────
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

  // ── Skills wrap (with add button) ─────────────────────────────────────────
  Widget _buildSkillsWrap() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._allSkills.map((skill) {
          final isSelected = _selectedSkills.contains(skill);
          return _chip(
            label: skill,
            selected: isSelected,
            onTap: () => setState(() {
              isSelected
                  ? _selectedSkills.remove(skill)
                  : _selectedSkills.add(skill);
            }),
          );
        }),
        // Add button
        GestureDetector(
          onTap: _showAddSkillDialog,
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

  // ── Single-select pill row ────────────────────────────────────────────────
  Widget _buildSingleSelectRow({
    required List<String> options,
    required String selected,
    required void Function(String) onSelect,
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

  // ── Multi-select wrap ─────────────────────────────────────────────────────
  Widget _buildMultiSelectWrap({
    required List<String> options,
    required List<String> selected,
    required void Function(String) onToggle,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((o) {
        return _chip(
            label: o,
            selected: selected.contains(o),
            onTap: () => onToggle(o));
      }).toList(),
    );
  }

  // ── Reusable chip ─────────────────────────────────────────────────────────
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
          color: selected ? _purple : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _purple : _border,
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
              const Icon(Icons.check_rounded,
                  size: 13, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  // ── Continue button ───────────────────────────────────────────────────────
  Widget _buildContinueButton() {
    final canContinue = _selectedSkills.isNotEmpty;
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
          opacity: canContinue ? 1.0 : 0.4,
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: canContinue
                ? () => Navigator.pushNamed(context, '/register3')
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _purple,
              foregroundColor: Colors.white,
              disabledBackgroundColor: _purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,

                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Add Skill Dialog ──────────────────────────────────────────────────────
  void _showAddSkillDialog() {
    final controller = TextEditingController();
    String? errorText;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (_, animation, __, child) {
        final curved =
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _purple.withOpacity(0.18),
                              _surface,
                            ],
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
                                color: _purple.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: const Icon(Icons.auto_awesome_rounded,
                                  size: 18, color: _purple),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Add a Skill',
                                    style: TextStyle(
                                      color: _bg,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.3,
                                    )),
                                SizedBox(height: 2),
                                Text('Appears on your profile',
                                    style: TextStyle(
                                        color: _bg, fontSize: 12)),
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
                            // Input
                            TextField(
                              controller: controller,
                              autofocus: true,
                              style: const TextStyle(
                                  color: _textPrimary,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                hintText: 'e.g. Next.js, Figma, Python…',
                                hintStyle:
                                const TextStyle(color: _textSecondary),
                                errorText: errorText,
                                prefixIcon: const Icon(Icons.code_rounded,
                                    size: 15, color: _textSecondary),
                                filled: true,
                                fillColor: _bg,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                  const BorderSide(color: _border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                  const BorderSide(color: _border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                      color: _purple, width: 1.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 13),
                              ),
                              onChanged: (_) {
                                if (errorText != null) {
                                  setDialogState(() => errorText = null);
                                }
                              },
                              onSubmitted: (_) => _handleAdd(
                                  controller, setDialogState, (e) {
                                errorText = e;
                              }),
                            ),

                            // Live chip preview
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutCubic,
                              child: ValueListenableBuilder(
                                valueListenable: controller,
                                builder: (_, value, __) {
                                  final text = value.text.trim();
                                  if (text.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text('PREVIEW',
                                            style: TextStyle(
                                                color: _bg,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1.0)),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: _purple,
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(text,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  )),
                                              const SizedBox(width: 6),
                                              const Icon(
                                                  Icons.check_rounded,
                                                  size: 13,
                                                  color: Colors.white),
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

                      // Actions
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  backgroundColor: _bg,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: _bg),
                                  ),
                                ),
                                child: const Text('Cancel',
                                    style: TextStyle(color: _textSecondary)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: () => _handleAdd(
                                    controller, setDialogState, (e) {
                                  errorText = e;
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _purple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.add_rounded, size: 16),
                                label: const Text('Add Skill',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700)),
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
      void Function(String?) setError,
      ) {
    final newSkill = controller.text.trim();
    if (newSkill.isEmpty) {
      setDialogState(() => setError('Please enter a skill name'));
      return;
    }
    if (_selectedSkills.contains(newSkill)) {
      setDialogState(() => setError("You've already added this skill"));
      return;
    }
    setState(() {
      if (!_allSkills.contains(newSkill)) _allSkills.add(newSkill);
      _selectedSkills.add(newSkill);
    });
    Navigator.pop(context);
  }
}