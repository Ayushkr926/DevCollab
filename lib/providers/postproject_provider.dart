// lib/providers/postproject_provider.dart

import 'package:flutter/material.dart';

class ProjectRole {
  String label;
  ProjectRole({required this.label});
}

enum PostProjectStep { basics, requirements, logistics }

class PostProjectProvider extends ChangeNotifier {
  // ── Controllers ────────────────────────────────────────────────────────────
  final titleController       = TextEditingController();
  final descriptionController = TextEditingController();
  final teamSizeController    = TextEditingController();
  final githubLinkController  = TextEditingController();
  final figmaLinkController   = TextEditingController();
  final roleInputController   = TextEditingController();
  final roleFocusNode         = FocusNode();

  // ── Step tracking ──────────────────────────────────────────────────────────
  PostProjectStep _step = PostProjectStep.basics;
  PostProjectStep get step => _step;
  int get stepIndex => _step.index;

  // ── Static option lists ───────────────────────────────────────────────────
  final List<String> allSkills = const [
    'Flutter', 'Node.js', 'React', 'Vue.js', 'Python', 'MongoDB',
    'Firebase', 'Swift', 'Kotlin', 'Figma', 'Docker', 'AWS',
    'ML/AI', 'GraphQL', 'Go', 'TypeScript',
  ];

  final List<String> projectTypes = const [
    'Hackathon', 'Freelance', 'Personal', 'Open-source',
  ];

  final List<String> categories = const [
    'AI/ML', 'Web', 'Mobile', 'Backend', 'Design', 'DevOps',
  ];

  final List<String> experienceLevels = const [
    'Any', 'Junior+', 'Mid+', 'Senior',
  ];

  final List<String> durationOptions = const [
    'Weekend', '1 week', 'Month', 'Long-term',
  ];

  final List<String> compensationOptions = const [
    'Unpaid / portfolio', 'Paid', 'Equity', 'Prize-split',
  ];

  final List<String> commsOptions = const [
    'Discord', 'WhatsApp', 'In-app chat', 'Slack',
  ];

  final List<String> openToOptions = const [
    'Hackathon', 'Freelance', 'Full-time', 'Open source',
  ];

  final List<String> availabilityOptions = const [
    'Available', 'Part-time', 'Busy',
  ];

  // ── Form state ─────────────────────────────────────────────────────────────
  String? projectType = 'Hackathon';
  String? category;
  Set<String> selectedSkills = {};
  List<ProjectRole> roles = [];
  String experience = 'Any';
  String? duration;
  String? compensation = 'Unpaid / portfolio';
  Set<String> selectedComms = {};
  DateTime? deadline;

  Set<String> openTo = {};
  String availability = 'Available';

  // ── Validation state ──────────────────────────────────────────────────────
  String? titleError;
  String? descriptionError;
  String? skillsError;
  String? rolesError;
  String? deadlineError;
  bool showValidation = false;

  // ── Step navigation ────────────────────────────────────────────────────────
  bool get canGoNext {
    switch (_step) {
      case PostProjectStep.basics:
        return _validateBasics(silent: true);
      case PostProjectStep.requirements:
        return _validateRequirements(silent: true);
      case PostProjectStep.logistics:
        return _validateLogistics(silent: true);
    }
  }

  bool nextStep() {
    bool valid;
    switch (_step) {
      case PostProjectStep.basics:
        valid = _validateBasics(silent: false);
        if (valid) _step = PostProjectStep.requirements;
        break;
      case PostProjectStep.requirements:
        valid = _validateRequirements(silent: false);
        if (valid) _step = PostProjectStep.logistics;
        break;
      case PostProjectStep.logistics:
        valid = _validateLogistics(silent: false);
        break;
    }
    notifyListeners();
    return valid;
  }

  void prevStep() {
    if (_step == PostProjectStep.requirements) {
      _step = PostProjectStep.basics;
    } else if (_step == PostProjectStep.logistics) {
      _step = PostProjectStep.requirements;
    }
    notifyListeners();
  }

  void goToStep(int index) {
    // Only allow jumping to a step you've already validated through
    if (index <= _step.index) {
      _step = PostProjectStep.values[index];
      notifyListeners();
    }
  }

  // ── Validation logic ───────────────────────────────────────────────────────
  bool _validateBasics({required bool silent}) {
    final titleOk = titleController.text.trim().isNotEmpty &&
        titleController.text.trim().length <= 80;
    final descOk = descriptionController.text.trim().isNotEmpty &&
        descriptionController.text.trim().length <= 600;

    if (!silent) {
      titleError = titleController.text.trim().isEmpty
          ? 'Title is required'
          : titleController.text.trim().length > 80
          ? 'Title must be under 80 characters'
          : null;
      descriptionError = descriptionController.text.trim().isEmpty
          ? 'Description is required'
          : descriptionController.text.trim().length > 600
          ? 'Description must be under 600 characters'
          : null;
    }
    return titleOk && descOk;
  }

  bool _validateRequirements({required bool silent}) {
    final skillsOk = selectedSkills.isNotEmpty;
    final rolesOk = roles.isNotEmpty;

    if (!silent) {
      skillsError = skillsOk ? null : 'Select at least 1 required skill';
      rolesError = rolesOk ? null : 'Add at least 1 role needed';
    }
    return skillsOk && rolesOk;
  }

  bool _validateLogistics({required bool silent}) {
    final deadlineOk = deadline != null;

    if (!silent) {
      deadlineError = deadlineOk ? null : 'Deadline is required';
    }
    return deadlineOk;
  }

  // ── Field setters ──────────────────────────────────────────────────────────
  void onTitleChanged(String _) {
    if (titleError != null) {
      titleError = null;
      notifyListeners();
    }
  }

  void onDescriptionChanged(String _) {
    if (descriptionError != null) {
      descriptionError = null;
      notifyListeners();
    }
  }

  void setProjectType(String type) {
    projectType = type;
    notifyListeners();
  }

  void setCategory(String cat) {
    category = category == cat ? null : cat;
    notifyListeners();
  }

  void toggleSkill(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
    }
    skillsError = null;
    notifyListeners();
  }

  void addRole() {
    final text = roleInputController.text.trim();
    if (text.isEmpty) return;
    if (roles.any((r) => r.label.toLowerCase() == text.toLowerCase())) {
      roleInputController.clear();
      return;
    }
    roles.add(ProjectRole(label: text));
    roleInputController.clear();
    rolesError = null;
    notifyListeners();
  }

  void removeRole(int index) {
    roles.removeAt(index);
    notifyListeners();
  }

  void setExperience(String level) {
    experience = level;
    notifyListeners();
  }

  void setDuration(String d) {
    duration = duration == d ? null : d;
    notifyListeners();
  }

  void setCompensation(String c) {
    compensation = c;
    notifyListeners();
  }

  void toggleComms(String comm) {
    if (selectedComms.contains(comm)) {
      selectedComms.remove(comm);
    } else {
      selectedComms.add(comm);
    }
    notifyListeners();
  }

  void setDeadline(DateTime date) {
    deadline = date;
    deadlineError = null;
    notifyListeners();
  }

  void toggleOpenTo(String option) {
    if (openTo.contains(option)) {
      openTo.remove(option);
    } else {
      openTo.add(option);
    }
    notifyListeners();
  }

  void setAvailability(String option) {
    availability = option;
    notifyListeners();
  }

  // ── Submission state ───────────────────────────────────────────────────────
  bool isSubmitting = false;
  bool isSuccess = false;

  Future<bool> submit() async {
    if (!_validateBasics(silent: false) ||
        !_validateRequirements(silent: false) ||
        !_validateLogistics(silent: false)) {
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    notifyListeners();

    try {
      // Simulate API call — replace with real Dio POST /api/projects
      await Future.delayed(const Duration(milliseconds: 1200));

      isSubmitting = false;
      isSuccess = true;
      notifyListeners();
      return true;
    } catch (e) {
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  Map<String, dynamic> getFormData() {
    return {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'type': projectType,
      'category': category,
      'techStack': selectedSkills.toList(),
      'rolesNeeded': roles.map((r) => {'label': r.label, 'isFilled': false}).toList(),
      'experienceLevel': experience,
      'teamSize': teamSizeController.text.trim(),
      'duration': duration,
      'compensation': compensation,
      'preferredComms': selectedComms.toList(),
      'deadline': deadline?.toIso8601String(),
      'links': {
        'github': githubLinkController.text.trim(),
        'figma': figmaLinkController.text.trim(),
      },
    };
  }

  // ── Profile strength style completeness meter ────────────────────────────
  int get completionPercent {
    int filled = 0;
    const total = 11;
    if (titleController.text.trim().isNotEmpty) filled++;
    if (descriptionController.text.trim().isNotEmpty) filled++;
    if (projectType != null) filled++;
    if (category != null) filled++;
    if (selectedSkills.isNotEmpty) filled++;
    if (roles.isNotEmpty) filled++;
    if (experience != 'Any') filled++;
    if (duration != null) filled++;
    if (compensation != null) filled++;
    if (selectedComms.isNotEmpty) filled++;
    if (deadline != null) filled++;
    return ((filled / total) * 100).round();
  }

  void disposeControllers() {
    titleController.dispose();
    descriptionController.dispose();
    teamSizeController.dispose();
    githubLinkController.dispose();
    figmaLinkController.dispose();
    roleInputController.dispose();
    roleFocusNode.dispose();
  }
}