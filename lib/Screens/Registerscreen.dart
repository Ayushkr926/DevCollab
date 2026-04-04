import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/AppColors.dart';
import '../widgets/AuthTextfield.dart';
import '../widgets/Step_progress_widgets.dart';
import '../widgets/primarybutton.dart';
import '../widgets/social_auth_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  // ── Form ─────────────────────────────
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  // ── State ────────────────────────────
  bool _obscurePassword = true;
  bool _isLoading = false;
  int _currentStep = 1;

  String? _globalError;


  Future<void> _handleGitHubLogin() async {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('GitHub OAuth — coming soon!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Google OAuth ──────────────────────────────────────────────────────────
  Future<void> _handleGoogleLogin() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Google Sign-In — coming soon!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenH - 80),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: screenH * 0.05),

                      // 🔥 Progress Bar
                      _buildProgress(),

                      const SizedBox(height: 30),

                      // Header
                      _buildHeader(),

                      const SizedBox(height: 30),

                      if (_globalError != null)
                        Text(
                          _globalError!,
                          style: const TextStyle(color: Colors.red),
                        ),

                      const SizedBox(height: 10),

                      // Fields
                      _buildFormFields(),

                      const SizedBox(height: 24),

                      _buildButton(),

                      const Spacer(),
                      _buildDivider(),

                      const SizedBox(height: 16),

                      // ── Social buttons ──────────────────────────────────
                      _buildSocialButtons(),


                      const SizedBox(height: 16),

                      _buildLoginLink(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 0.5, color: const Color(0xFFE8E6DF))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF888780),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Container(height: 0.5, color: const Color(0xFFE8E6DF))),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: SocialAuthButton(
            label: 'GitHub',
            icon: _githubIcon(),
            onPressed: _handleGitHubLogin,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SocialAuthButton(
            label: 'Google',
            icon: _googleIcon(),
            onPressed: _handleGoogleLogin,
          ),
        ),
      ],
    );
  }

  Widget _githubIcon() {
    return CustomPaint(
      size: const Size(16, 16),
      painter: _GitHubIconPainter(),
    );
  }

  Widget _googleIcon() {
    return CustomPaint(
      size: const Size(16, 16),
      painter: _GoogleIconPainter(),
    );
  }

  // ── Progress Bar ─────────────────────
  Widget _buildProgress() {
    return StepProgressBar(
      currentStep: 1,
      totalSteps: 3,
    );
  }

  // ── Header ───────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.person_add, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        const Text(
          "Create Account",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Join DevCollab and start building",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  // ── Fields ───────────────────────────
  Widget _buildFormFields() {
    return Column(
      children: [
        AuthTextField(
          controller: _nameController,
          focusNode: _nameFocus,
          label: "Full Name",
          hint: "Ayush Kumar",
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.person_outline,
          onSubmitted: (_) => _emailFocus.requestFocus(),
        ),

        const SizedBox(height: 12),

        AuthTextField(
          controller: _emailController,
          focusNode: _emailFocus,
          label: "Email",
          hint: "example@mail.com",
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.mail_outline,
          onSubmitted: (_) => _passwordFocus.requestFocus(),
        ),

        const SizedBox(height: 12),

        AuthTextField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          label: "Password",
          hint: "••••••••",
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outline,
          suffixIcon: _obscurePassword
              ? Icons.visibility_off
              : Icons.visibility,
          onSuffixTap: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
      ],
    );
  }

  // ── Button ───────────────────────────
  Widget _buildButton() {
    return PrimaryButton(
      label: "Create Account",
      isLoading: _isLoading,
      onPressed: () {
        // TODO: Register API
        Navigator.pushNamed(context, '/register2');
      },
    );
  }

  // ── Bottom Link ──────────────────────
  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: const TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: "Login",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ── GitHub icon painter ───────────────────────────────────────────────────────
class _GitHubIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;

    // Simplified GitHub cat icon using path approximation
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Outer circle body
    path.addOval(Rect.fromCircle(center: Offset(w / 2, h / 2), radius: w / 2));

    canvas.drawPath(path, paint);

    // White inner detail
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    // Simple GitHub-like mark
    canvas.drawCircle(Offset(w / 2, h / 2.2), w * 0.22, whitePaint);
    canvas.drawLine(
      Offset(w * 0.3, h * 0.65),
      Offset(w * 0.3, h * 0.82),
      whitePaint,
    );
    canvas.drawLine(
      Offset(w * 0.7, h * 0.65),
      Offset(w * 0.7, h * 0.82),
      whitePaint,
    );
    canvas.drawArc(
      Rect.fromLTWH(w * 0.22, h * 0.62, w * 0.56, h * 0.28),
      0,
      3.14159,
      false,
      whitePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ── Google icon painter ───────────────────────────────────────────────────────
class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    // Red arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // top
      3.14159, // 180°
      false,
      Paint()
        ..color = const Color(0xFFE24B4A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // Blue arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.5708,
      1.0472,
      false,
      Paint()
        ..color = const Color(0xFF378ADD)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // Green arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.6180,
      1.0472,
      false,
      Paint()
        ..color = const Color(0xFF1D9E75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // Horizontal bar
    canvas.drawLine(
      Offset(w * 0.5, h * 0.5),
      Offset(w * 0.92, h * 0.5),
      Paint()
        ..color = const Color(0xFF378ADD)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}