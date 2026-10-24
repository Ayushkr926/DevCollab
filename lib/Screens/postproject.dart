// lib/screens/post_project_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/postproject_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/postfield.dart';

class PostProject extends StatefulWidget {
  const PostProject({super.key});

  @override
  State<PostProject> createState() => _PostProjectState();
}

class _PostProjectState extends State<PostProject> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostProjectProvider(),
      child: const _PostProjectContent(),
    );
  }
}

class _PostProjectContent extends StatefulWidget {
  const _PostProjectContent();

  @override
  State<_PostProjectContent> createState() => _PostProjectContentState();
}

class _PostProjectContentState extends State<_PostProjectContent>
    with TickerProviderStateMixin {
  final _scrollCtrl = ScrollController();

  late final AnimationController _transitionCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  int _lastStep = 0;

  @override
  void initState() {
    super.initState();
    _transitionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fade = CurvedAnimation(parent: _transitionCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _transitionCtrl, curve: Curves.easeOut));
    _transitionCtrl.forward();
  }

  @override
  void dispose() {
    context.read<PostProjectProvider>().disposeControllers();
    _transitionCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _animateToStep() {
    _transitionCtrl.forward(from: 0);
    _scrollCtrl.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  Future<void> _handleNext(PostProjectProvider provider) async {
    if (provider.step == PostProjectStep.logistics) {
      final success = await provider.submit();
      if (success && mounted) {
        _showSuccessSheet(context);
      } else {
        HapticFeedback.heavyImpact();
      }
      return;
    }

    final ok = provider.nextStep();
    if (ok) {
      HapticFeedback.selectionClick();
      _animateToStep();
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void _showSuccessSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SuccessSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProjectProvider>();

    if (provider.stepIndex != _lastStep) {
      _lastStep = provider.stepIndex;
    }

    return Scaffold(
      backgroundColor: DC.bg1,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: DC.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Post a project',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: DC.textPrimary, letterSpacing: -0.3),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: PpCompletionBadge(percent: provider.completionPercent)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: PpStepHeader(
              currentStep: provider.stepIndex,
              onStepTap: provider.goToStep,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              padding: const EdgeInsets.only(top: 4, bottom: 24),
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: _buildStepContent(provider),
                ),
              ),
            ),
          ),
          PpBottomBar(
            showBack: provider.step != PostProjectStep.basics,
            onBack: () { provider.prevStep(); _animateToStep(); },
            primaryLabel: provider.step == PostProjectStep.logistics ? 'Post project' : 'Continue',
            isLoading: provider.isSubmitting,
            onPrimary: () => _handleNext(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(PostProjectProvider p) {
    switch (p.step) {
      case PostProjectStep.basics:
        return _BasicsStep(key: const ValueKey('basics'));
      case PostProjectStep.requirements:
        return _RequirementsStep(key: const ValueKey('requirements'));
      case PostProjectStep.logistics:
        return _LogisticsStep(key: const ValueKey('logistics'));
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 1 — Basics
// ─────────────────────────────────────────────────────────────────────────────
class _BasicsStep extends StatelessWidget {
  const _BasicsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PostProjectProvider>();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('What are you building?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: DC.textPrimary, letterSpacing: -0.3)),
          const SizedBox(height: 4),
          Text('Give it a clear name and explain what you need help with.', style: DCText.caption),
          const SizedBox(height: 18),

          PpField(
            controller: p.titleController,
            label: 'Project title',
            hint: 'AI Study Buddy App',
            prefixIcon: Icons.edit_outlined,
            maxLength: 80,
            errorText: p.titleError,
            onChanged: p.onTitleChanged,
          ),

          PpField(
            controller: p.descriptionController,
            label: 'Description',
            hint: 'Building an AI-powered study companion for students. Need Flutter + ML engineers...',
            prefixIcon: Icons.notes_rounded,
            maxLength: 600,
            maxLines: 4,
            errorText: p.descriptionError,
            onChanged: p.onDescriptionChanged,
          ),

          PpSectionLabel(title: 'Project type'),
          Wrap(
            children: p.projectTypes.map((t) => Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 6),
              child: PpChip(label: t, selected: p.projectType == t, onTap: () => p.setProjectType(t)),
            )).toList(),
          ),

          const SizedBox(height: 10),
          PpSectionLabel(title: 'Category', required: false),
          Wrap(
            children: p.categories.map((c) => Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 6),
              child: PpChip(label: c, selected: p.category == c, onTap: () => p.setCategory(c)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 2 — Requirements
// ─────────────────────────────────────────────────────────────────────────────
class _RequirementsStep extends StatelessWidget {
  const _RequirementsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PostProjectProvider>();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Who do you need?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: DC.textPrimary, letterSpacing: -0.3)),
          const SizedBox(height: 4),
          Text('Define the skills and roles for your team.', style: DCText.caption),
          const SizedBox(height: 18),

          PpSectionLabel(title: 'Tech stack required', errorText: p.skillsError),
          Wrap(
            children: p.allSkills.map((s) => Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 6),
              child: PpChip(label: s, selected: p.selectedSkills.contains(s), onTap: () => p.toggleSkill(s)),
            )).toList(),
          ),
          const SizedBox(height: 16),

          PpSectionLabel(title: 'Roles needed', errorText: p.rolesError),
          ...p.roles.asMap().entries.map((e) => PpRoleRow(
            label: e.value.label,
            onDelete: () => p.removeRole(e.key),
          )),
          PpRoleInput(
            controller: p.roleInputController,
            focusNode: p.roleFocusNode,
            onAdd: p.addRole,
          ),

          const SizedBox(height: 16),
          PpSectionLabel(title: 'Experience level needed', required: false),
          PpSegment(options: p.experienceLevels, selected: p.experience, onSelect: p.setExperience),

          const SizedBox(height: 16),
          PpSectionLabel(title: 'Team size', required: false),
          PpField(
            controller: p.teamSizeController,
            label: '',
            hint: 'e.g. 3 members (incl. you)',
            prefixIcon: Icons.groups_outlined,
            required: false,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 3 — Logistics
// ─────────────────────────────────────────────────────────────────────────────
class _LogisticsStep extends StatelessWidget {
  const _LogisticsStep({super.key});

  Future<void> _pickDate(BuildContext context, PostProjectProvider p) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: DC.bg0),
        ),
        child: child!,
      ),
    );
    if (picked != null) p.setDeadline(picked);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PostProjectProvider>();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Final details', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: DC.textPrimary, letterSpacing: -0.3)),
          const SizedBox(height: 4),
          Text('Timing, compensation, and how you want to be reached.', style: DCText.caption),
          const SizedBox(height: 18),

          PpSectionLabel(title: 'Deadline / event date', errorText: p.deadlineError),
          GestureDetector(
            onTap: () => _pickDate(context, p),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: p.deadlineError != null ? const Color(0xFFFCEBEB) : Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: p.deadlineError != null ? DC.border : DC.border, width: .5),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 15,
                      color: p.deadline != null ? DC.bg0 : DC.textSecondary),
                  const SizedBox(width: 10),
                  Text(
                    p.deadline != null
                        ? DateFormat('MMM d, yyyy').format(p.deadline!)
                        : 'Select a date',
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: p.deadline != null ? DC.textPrimary : DC.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, size: 16, color: DC.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          PpSectionLabel(title: 'Estimated duration', required: false),
          PpSegment(options: p.durationOptions, selected: p.duration, onSelect: p.setDuration),
          const SizedBox(height: 16),

          PpSectionLabel(title: 'Compensation', required: false),
          Wrap(
            children: p.compensationOptions.map((c) => Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 6),
              child: PpChip(label: c, selected: p.compensation == c, onTap: () => p.setCompensation(c)),
            )).toList(),
          ),
          const SizedBox(height: 16),

          PpSectionLabel(title: 'Preferred comms', required: false),
          Wrap(
            children: p.commsOptions.map((c) => Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 6),
              child: PpChip(label: c, selected: p.selectedComms.contains(c), onTap: () => p.toggleComms(c)),
            )).toList(),
          ),
          const SizedBox(height: 16),

          PpSectionLabel(title: 'External links', required: false),
          PpField(
            controller: p.githubLinkController,
            label: '',
            hint: 'GitHub repo URL',
            prefixIcon: Icons.code_rounded,
            required: false,
          ),
          PpField(
            controller: p.figmaLinkController,
            label: '',
            hint: 'Figma / design URL',
            prefixIcon: Icons.brush_outlined,
            required: false,
          ),

          const SizedBox(height: 4),
          PpSectionLabel(title: 'Cover image', required: false),
          DottedUploadBox(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dotted upload placeholder
// ─────────────────────────────────────────────────────────────────────────────
class DottedUploadBox extends StatelessWidget {
  const DottedUploadBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: DC.bg1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: DC.border, width: 1.4, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: DC.bg0, shape: BoxShape.circle),
              child: const Icon(Icons.add_photo_alternate_outlined, size: 18, color: DC.bg0),
            ),
            const SizedBox(height: 8),
            Text('Upload a banner image', style: DCText.caption.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text('Optional · PNG or JPG, max 5MB', style: DCText.micro),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Success bottom sheet shown after posting
// ─────────────────────────────────────────────────────────────────────────────
class _SuccessSheet extends StatefulWidget {
  const _SuccessSheet();

  @override
  State<_SuccessSheet> createState() => _SuccessSheetState();
}

class _SuccessSheetState extends State<_SuccessSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 36, 24, 24 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scale,
            child: Container(
              width: 72, height: 72,
              decoration: const BoxDecoration(color: DC.primary, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: DC.primary, size: 34),
            ),
          ),
          const SizedBox(height: 18),
          const Text('Project posted!', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: DC.textPrimary, letterSpacing: -0.3)),
          const SizedBox(height: 6),
          Text(
            'Your project is now live. Developers can find and apply to it from the Explore tab.',
            textAlign: TextAlign.center,
            style: DCText.caption.copyWith(height: 1.6),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: DC.bg0, borderRadius: BorderRadius.circular(13)),
                child: const Center(
                  child: Text('View my project', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () { Navigator.of(context).pop(); Navigator.of(context).pop(); },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Back to home', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: DC.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}