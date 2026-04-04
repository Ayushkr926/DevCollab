import 'dart:io';
import 'package:devcollab/widgets/Step_progress_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen3 extends StatefulWidget {
  const RegisterScreen3({super.key});

  @override
  State<RegisterScreen3> createState() => _RegisterScreen3State();
}

class _RegisterScreen3State extends State<RegisterScreen3>
    with SingleTickerProviderStateMixin {
  // ── Constants ─────────────────────────
  static const _purple = Color(0xFF6C63FF);
  static const _bg = Colors.white;
  static const _surface = Color(0xFF1E1E2A);
  static const _border = Color(0xFF2E2E3E);
  static const _textPrimary = Colors.black;
  static const _textSecondary = Color(0xFF2B2B2C);
  static const _orange = Color(0xFFFF9F43);

  // ── State ─────────────────────────────
  File? _avatarFile;
  final _bioController = TextEditingController();
  final _cityController = TextEditingController();
  final _githubController = TextEditingController();

  bool _githubVerified = false;
  bool _cityValid = false;
  bool _isLoading = false;

  late AnimationController _avatarAnim;
  late Animation<double> _avatarScale;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _avatarAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _avatarScale = CurvedAnimation(
      parent: _avatarAnim,
      curve: Curves.elasticOut,
    );
    _avatarAnim.forward();

    _githubController.addListener(_onGithubChanged);
    _cityController.addListener(() {
      setState(() => _cityValid = _cityController.text.trim().length > 2);
    });
  }

  void _onGithubChanged() {
    final v = _githubController.text.trim();
    setState(() => _githubVerified = v.length >= 3);
  }

  @override
  void dispose() {
    _avatarAnim.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 400,
    );
    if (picked != null) {
      setState(() => _avatarFile = File(picked.path));
      _avatarAnim
        ..reset()
        ..forward();
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: _border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload Photo',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _sourceButton(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _sourceButton(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(
          children: [
            Icon(icon, color: _purple, size: 26),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [

              // ── Progress bar (all 3 filled) ───────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: StepProgressBar(currentStep: 3, totalSteps: 3),
              ),

              // ── Scrollable body ───────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const Text(
                        'Almost there!',
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
                        'Make your profile stand out',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Avatar ──────────────────────────
                      Center(
                        child: Column(
                          children: [
                            ScaleTransition(
                              scale: _avatarScale,
                              child: GestureDetector(
                                onTap: _showImageSourceSheet,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Dashed border ring
                                    Container(
                                      width: 104,
                                      height: 104,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _purple.withOpacity(0.5),
                                          width: 2,
                                          strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                        ),
                                      ),
                                    ),
                                    // Avatar circle
                                    Container(
                                      width: 96,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _purple.withOpacity(0.15),
                                        border: Border.all(
                                          color: _purple.withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: _avatarFile != null
                                          ? ClipOval(
                                        child: Image.file(
                                          _avatarFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                          : const Center(
                                        child: Text(
                                          'AK',
                                          style: TextStyle(
                                            color: _purple,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Camera badge
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: _purple,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: _bg, width: 2),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt_rounded,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Tap to upload photo',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Camera / Gallery pills
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _pillButton(
                                  label: 'Camera',
                                  filled: true,
                                  onTap: () async {
                                    final p = await _picker.pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 85);
                                    if (p != null) {
                                      setState(() =>
                                      _avatarFile = File(p.path));
                                    }
                                  },
                                ),
                                const SizedBox(width: 10),
                                _pillButton(
                                  label: 'Gallery',
                                  filled: false,
                                  onTap: () async {
                                    final p = await _picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 85);
                                    if (p != null) {
                                      setState(() =>
                                      _avatarFile = File(p.path));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── BIO ─────────────────────────────
                      _sectionLabel('BIO / TAGLINE', badge: 'OPTIONAL',
                          badgeColor: _orange),
                      const SizedBox(height: 10),
                      _buildBioField(),

                      const SizedBox(height: 24),

                      // ── CITY ────────────────────────────
                      _sectionLabel('CITY / LOCATION', badge: 'OPTIONAL',
                          badgeColor: _orange),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _cityController,
                        hint: 'New Delhi, India',
                        showCheck: _cityValid,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 24),

                      // ── GITHUB ──────────────────────────
                      _sectionLabel('GITHUB USERNAME',
                          badge: 'RECOMMENDED', badgeColor: _purple),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _githubController,
                        hint: 'aryandev',
                        showCheck: _githubVerified,
                        textInputAction: TextInputAction.done,
                      ),
                      if (_githubVerified) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            'github.com/${_githubController.text.trim()} — verified ✓',
                            style: const TextStyle(
                              color: Color(0xFF4CAF50),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // ── Bottom buttons ────────────────────
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section label with badge ──────────────────────────────────────────────
  Widget _sectionLabel(String text,
      {String? badge, Color badgeColor = _purple}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Text(
            badge,
            style: TextStyle(
              color: badgeColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ],
    );
  }

  // ── Bio textarea ──────────────────────────────────────────────────────────
  Widget _buildBioField() {
    return ValueListenableBuilder(
      valueListenable: _bioController,
      builder: (_, value, __) {
        final charCount = value.text.length;
        return Container(
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              TextField(
                controller: _bioController,
                maxLines: 4,
                maxLength: 150,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                null,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 15,
                  height: 1.5,
                ),
                decoration: const InputDecoration(
                  hintText:
                  'Flutter + Node.js dev. Open to hackathons & freelance.',
                  hintStyle: TextStyle(color: _textSecondary, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 12, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$charCount / 150',
                      style: TextStyle(
                        color: charCount > 130
                            ? _orange
                            : _bg,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Generic text field ────────────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool showCheck = false,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: showCheck ? const Color(0xFF4CAF50).withOpacity(0.5) : _border,
        ),
      ),
      child: TextField(
        controller: controller,
        textInputAction: textInputAction,
        style: const TextStyle(
          color: _textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _textSecondary, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 15),
          suffixIcon: showCheck
              ? const Icon(Icons.check_rounded,
              color: Color(0xFF4CAF50), size: 20)
              : null,
        ),
      ),
    );
  }

  // ── Camera / Gallery pill ─────────────────────────────────────────────────
  Widget _pillButton({
    required String label,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
        decoration: BoxDecoration(
          color: filled ? _surface : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: filled ? _border : _border.withOpacity(0.6),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: filled ? _bg : _textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ── Bottom action buttons ─────────────────────────────────────────────────
  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      decoration: BoxDecoration(
        color: _bg,
        border: Border(
            top: BorderSide(color: _border.withOpacity(0.5))),
      ),
      child: Column(
        children: [
          // Primary CTA
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(seconds: 2));
                if (mounted) {
                  setState(() => _isLoading = false);
                  // TODO: final submit
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (_) => false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Create my account →',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Secondary skip
          SizedBox(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (_) => false),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: _border),
                ),
              ),
              child: const Text(
                'Skip for now — fill in later',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}