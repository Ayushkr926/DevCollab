
import 'package:devcollab/widgets/Step_progress_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/register3_provider.dart';
import '../utils/app_theme.dart';

class RegisterScreen3 extends StatelessWidget {
  const RegisterScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterStep3Provider(),
      child: const _RegisterScreen3Content(),
    );
  }
}

class _RegisterScreen3Content extends StatelessWidget {
  const _RegisterScreen3Content();

  static const _purple = DC.bg2;
  static const _bg = DC.bg2;
  static const _surface = DC.bg0;
  static const _border = Color(0xFF2E2E3E);
  static const _textPrimary = DC.textPrimary;
  static const _textSecondary = DC.textSecondary;
  static const _orange = Color(0xFFFF9F43);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterStep3Provider>();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: StepProgressBar(currentStep: 3, totalSteps: 3),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      const SizedBox(height: 12),

                      // Avatar
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _showImageSourceSheet(context, provider),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 104,
                                    height: 104,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _purple.withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 96,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _purple.withOpacity(0.15),
                                      border: Border.all(color: _purple.withOpacity(0.3), width: 1.5),
                                    ),
                                    child: provider.avatarFile != null
                                        ? ClipOval(
                                      child: Image.file(
                                        provider.avatarFile!,
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
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: _purple,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: _bg, width: 2),
                                      ),
                                      child: const Icon(Icons.camera_alt_rounded, size: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text('Tap to upload photo', style: TextStyle(color: _textSecondary, fontSize: 13)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _pillButton('Camera', true, () => provider.pickImage(ImageSource.camera, context: context)),
                                const SizedBox(width: 10),
                                _pillButton('Gallery', false, () => provider.pickImage(ImageSource.gallery, context: context)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Bio
                      _sectionLabel('BIO / TAGLINE', badge: 'OPTIONAL', badgeColor: _orange),
                      const SizedBox(height: 10),
                      _buildBioField(provider),

                      const SizedBox(height: 24),

                      // City
                      _sectionLabel('CITY / LOCATION', badge: 'OPTIONAL', badgeColor: _orange),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: provider.cityController,
                        hint: 'New Delhi, India',
                        showCheck: provider.cityValid,
                      ),

                      const SizedBox(height: 24),

                      // GitHub
                      _sectionLabel('GITHUB Url', badge: 'RECOMMENDED', badgeColor: _purple),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: provider.githubController,
                        hint: 'Aryan***',
                        showCheck: provider.githubVerified,
                      ),

                      const SizedBox(height: 24),
                      _sectionLabel('Leetcode Url', badge: 'RECOMMENDED', badgeColor: _purple),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: provider.leetcodeController,
                        hint: 'Aryan***',
                        showCheck: provider.githubVerified,
                      ),

                      const SizedBox(height: 24),
                      _sectionLabel('Linkedin Url', badge: 'RECOMMENDED', badgeColor: _purple),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: provider.linkinController,
                        hint: 'Aryan***',
                        showCheck: provider.githubVerified,
                      ),

                      // if (provider.githubVerified) ...[
                      //   const SizedBox(height: 6),
                      //   Padding(
                      //     padding: const EdgeInsets.only(left: 4),
                      //     child: Text(
                      //       'github.com/${provider.githubController.text.trim()} — verified ✓',
                      //       style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 12, fontWeight: FontWeight.w500),
                      //     ),
                      //   ),
                      // ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              _buildBottomButtons(context, provider),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper Widgets (same as before, just adapted) ─────────────────────

  Widget _sectionLabel(String text, {String? badge, Color badgeColor = Colors.purple}) {
    return Row(
      children: [
        Text(text, style: const TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Text(badge, style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ],
    );
  }

  Widget _buildBioField(RegisterStep3Provider provider) {
    return ValueListenableBuilder(
      valueListenable: provider.bioController,
      builder: (_, value, __) {
        final charCount = value.text.length;
        return Container(
          decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
          child: Column(
            children: [
              TextField(
                controller: provider.bioController,
                maxLines: 4,
                maxLength: 150,
                style: const TextStyle(color: _textPrimary, fontSize: 15, height: 1.5),
                decoration: const InputDecoration(
                  hintText: 'Flutter + Node.js dev. Open to hackathons & freelance.',
                  hintStyle: TextStyle(color: _textSecondary, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),

            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool showCheck = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: showCheck ? const Color(0xFF4CAF50).withOpacity(0.5) : _border),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _textSecondary, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          suffixIcon: showCheck ? const Icon(Icons.check_rounded, color: Color(0xFF4CAF50), size: 20) : null,
        ),
      ),
    );
  }

  Widget _pillButton(String label, bool filled, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
        decoration: BoxDecoration(
          color: filled ? _surface : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border),
        ),
        child: Text(
          label,
          style: TextStyle(color: filled ? Colors.black : _textSecondary, fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context, RegisterStep3Provider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Upload Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _sourceButton(Icons.camera_alt_rounded, 'Camera', () => provider.pickImage(ImageSource.camera, context: context))),
                  const SizedBox(width: 12),
                  Expanded(child: _sourceButton(Icons.photo_library_rounded, 'Gallery', () => provider.pickImage(ImageSource.gallery, context: context))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sourceButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(
          children: [Icon(icon, color: _purple, size: 26), const SizedBox(height: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.w600))],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, RegisterStep3Provider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      decoration: BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _border.withOpacity(0.5))),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () async {
                final success = await provider.submitProfile();
                if (success && context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                } else if (provider.errorMessage != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(provider.errorMessage!)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: provider.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Create my account →', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
              style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: _border))),
              child: const Text('Skip for now — fill in later', style: TextStyle(color: _textSecondary, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}