import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../services/auth_service.dart';
import '../utils/AppColors.dart';
import '../utils/Appconstants.dart';
import '../utils/validator.dart';
import '../widgets/AuthTextfield.dart';
import '../widgets/primarybutton.dart';
import '../widgets/social_auth_button.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // ── Form ──────────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  // ── State ─────────────────────────────────────────────────────────────────
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;
  String? _globalError;

  // ── Animations ────────────────────────────────────────────────────────────
  late final AnimationController _entryController;
  late final AnimationController _shakeController;
  late final AnimationController _errorController;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoSlide;
  late final Animation<double> _formFade;
  late final Animation<double> _formSlide;
  late final Animation<double> _buttonFade;
  late final Animation<double> _shakeAnim;
  late final Animation<double> _errorFade;
  late final Animation<double> _errorSlide;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _entryController.forward();
    _loadSavedEmail();
  }

  void _setupAnimations() {
    // Entry animation — staggered reveal
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _logoSlide = Tween<double>(begin: -24.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _formFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.25, 0.7, curve: Curves.easeOut),
      ),
    );
    _formSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
      ),
    );
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Shake animation for wrong credentials
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // Error banner slide-down
    _errorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _errorFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _errorController, curve: Curves.easeOut),
    );
    _errorSlide = Tween<double>(begin: -12.0, end: 0.0).animate(
      CurvedAnimation(parent: _errorController, curve: Curves.easeOut),
    );
  }

  Future<void> _loadSavedEmail() async {
    final user = await AuthService.getUser();
    if (user != null && mounted) {
      _emailController.text = user['email'] ?? '';
    }
  }

  // ── Validation ────────────────────────────────────────────────────────────
  bool _validateForm() {
    bool valid = true;
    setState(() {
      _emailError = null;
      _passwordError = null;
      _globalError = null;
    });

    final emailErr = Validators.email(_emailController.text.trim());
    if (emailErr != null) {
      setState(() => _emailError = emailErr);
      valid = false;
    }

    final passErr = Validators.loginPassword(_passwordController.text);
    if (passErr != null) {
      setState(() => _passwordError = passErr);
      valid = false;
    }

    return valid;
  }

  // ── Login API call ────────────────────────────────────────────────────────
  Future<void> _handleLogin() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_validateForm()) {
      _triggerShake();
      return;
    }

    setState(() {
      _isLoading = true;
      _globalError = null;
    });

    try {
      final dio = Dio();
      final response = await dio.post(
        '${AppConstants.baseUrl}/api/auth/login',
        data: {
          'email': _emailController.text.trim().toLowerCase(),
          'password': _passwordController.text,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final token = data['token'] as String;
        final user = data['user'] as Map<String, dynamic>;

        // Save token and user
        await AuthService.saveToken(token);
        await AuthService.saveUser(user);

        if (!mounted) return;

        // Navigate to home — clear the stack so back button doesn't go to login
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
              (route) => false,
        );
      }
    } on DioException catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['message'];

      if (statusCode == 401) {
        _globalError = 'Invalid email or password';
      } else if (statusCode == 403) {
        _globalError = 'Please verify your email';
      } else if (statusCode == 429) {
        _globalError = 'Too many attempts. Try later.';
      }
      // ✅ Correct way to check timeout
      else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        _globalError = 'Connection timeout. Check internet.';
      }
      else if (e.type == DioExceptionType.connectionError) {
        _globalError = 'No internet connection.';
      }
      else {
        _globalError = message ?? 'Something went wrong';
      }

      setState(() {});
      _errorController.forward(from: 0);
    }
  }

  void _triggerShake() {
    _shakeController.forward(from: 0).then((_) => _shakeController.reset());
  }

  // ── GitHub OAuth ──────────────────────────────────────────────────────────
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _entryController.dispose();
    _shakeController.dispose();
    _errorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenH - 80),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenH * 0.06),

                      // ── Logo + headline ─────────────────────────────────
                      _buildHeader(),

                      const SizedBox(height: 32),

                      // ── Error banner ────────────────────────────────────
                      if (_globalError != null) _buildErrorBanner(),

                      // ── Form fields ─────────────────────────────────────
                      _buildFormFields(),

                      const SizedBox(height: 6),

                      // ── Forgot password + Remember me ───────────────────
                      _buildFormExtras(),

                      const SizedBox(height: 22),

                      // ── Login button ────────────────────────────────────
                      _buildLoginButton(),

                      const SizedBox(height: 22),

                      // ── Divider ─────────────────────────────────────────
                      _buildDivider(),

                      const SizedBox(height: 16),

                      // ── Social buttons ──────────────────────────────────
                      _buildSocialButtons(),

                      const Spacer(),

                      // ── Register link ────────────────────────────────────
                      _buildRegisterLink(),

                      const SizedBox(height: 24),
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

  // ── Widgets ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) => Opacity(
        opacity: _logoFade.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, _logoSlide.value),
          child: child,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFAFA9EC), width: 0.5),
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(42, 42),
                painter: _MiniLayerPainter(),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Title
          RichText(
            textAlign: TextAlign.center, // ✅ VERY IMPORTANT
            text: TextSpan(
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
                letterSpacing: -1.0,
                height: 1.1,
              ),
              children: [
                const TextSpan(text: 'Welcome back'),
                TextSpan(
                  text: '!',
                  style: TextStyle(color: AppColors.primary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Subtitle
          const Text(
            'Sign in to your DevCollab account',
            textAlign: TextAlign.center, // ✅ important
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF888780),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return AnimatedBuilder(
      animation: _errorController,
      builder: (context, child) => Opacity(
        opacity: _errorFade.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, _errorSlide.value),
          child: child,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFCEBEB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF09595), width: 0.5),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFE24B4A),
              size: 16,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _globalError!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFA32D2D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() => _globalError = null);
                _errorController.reset();
              },
              child: const Icon(
                Icons.close_rounded,
                color: Color(0xFFA32D2D),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) => Opacity(
        opacity: _formFade.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, _formSlide.value),
          child: child,
        ),
      ),
      child: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          final shake = _shakeAnim.value;
          final dx = shake > 0
              ? 6.0 * (shake < 0.5 ? shake * 2 : (1 - shake) * 2) *
              (shake < 0.25 || (shake > 0.5 && shake < 0.75) ? -1 : 1)
              : 0.0;
          return Transform.translate(
            offset: Offset(dx * 8, 0),
            child: child,
          );
        },
        child: Column(
          children: [
            // Email field
            AuthTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              label: 'Email address',
              hint: 'aryan@dev.io',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              errorText: _emailError,
              prefixIcon: Icons.mail_outline_rounded,
              onChanged: (_) {
                if (_emailError != null) {
                  setState(() => _emailError = null);
                }
                if (_globalError != null) {
                  setState(() => _globalError = null);
                  _errorController.reset();
                }
              },
              onSubmitted: (_) => _passwordFocus.requestFocus(),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
            ),

            const SizedBox(height: 4),

            // Password field
            AuthTextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              label: 'Password',
              hint: '••••••••',
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              errorText: _passwordError,
              prefixIcon: Icons.lock_outline_rounded,
              suffixIcon: _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              onSuffixTap: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              onChanged: (_) {
                if (_passwordError != null) {
                  setState(() => _passwordError = null);
                }
                if (_globalError != null) {
                  setState(() => _globalError = null);
                  _errorController.reset();
                }
              },
              onSubmitted: (_) => _handleLogin(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormExtras() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) => Opacity(
        opacity: _formFade.value.clamp(0.0, 1.0),
        child: child,
      ),
      child: Row(
        children: [
          // Remember me
          GestureDetector(
            onTap: () => setState(() => _rememberMe = !_rememberMe),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: _rememberMe ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: _rememberMe
                          ? AppColors.primary
                          : const Color(0xFFD3D1C7),
                      width: 1.2,
                    ),
                  ),
                  child: _rememberMe
                      ? const Icon(Icons.check_rounded,
                      size: 12, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 7),
                const Text(
                  'Remember me',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF888780),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Forgot password
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/forgot-password'),
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) => Opacity(
        opacity: _buttonFade.value.clamp(0.0, 1.0),
        child: child,
      ),
      child: PrimaryButton(
        label: 'Sign in',
        isLoading: _isLoading,
        onPressed: _isLoading ? null : _handleLogin,
        icon: Icons.arrow_forward_rounded,
      ),
    );
  }

  Widget _buildDivider() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) => Opacity(
        opacity: _buttonFade.value.clamp(0.0, 1.0),
        child: child,
      ),
      child: Row(
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
      ),
    );
  }

  Widget _buildSocialButtons() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) => Opacity(
        opacity: _buttonFade.value.clamp(0.0, 1.0),
        child: child,
      ),
      child: Row(
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
      ),
    );
  }

  Widget _buildRegisterLink() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) => Opacity(
        opacity: _buttonFade.value.clamp(0.0, 1.0),
        child: child,
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF888780),
              fontWeight: FontWeight.w500,
            ),
            children: [
              const TextSpan(text: "New developer? "),
              TextSpan(
                text: 'Create account',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.of(context).pushNamed('/register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── SVG-style icon widgets ────────────────────────────────────────────────

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
}

// ── Mini logo painter ─────────────────────────────────────────────────────────
class _MiniLayerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF5B47E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    canvas.drawPath(
      Path()
        ..moveTo(w * 0.08, h * 0.71)
        ..lineTo(w * 0.5, h * 0.92)
        ..lineTo(w * 0.92, h * 0.71),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.08, h * 0.5)
        ..lineTo(w * 0.5, h * 0.71)
        ..lineTo(w * 0.92, h * 0.5),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.5, h * 0.08)
        ..lineTo(w * 0.08, h * 0.29)
        ..lineTo(w * 0.5, h * 0.5)
        ..lineTo(w * 0.92, h * 0.29)
        ..close(),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
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