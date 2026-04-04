import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ──────────────────────────────────────────────────
  late final AnimationController _logoController;
  late final AnimationController _floatController;
  late final AnimationController _textController;
  late final AnimationController _dotsController;

  // ── Logo animations ────────────────────────────────────────────────────────
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoRotate;

  // ── Float animation (up-down) ──────────────────────────────────────────────
  late final Animation<double> _floatY;

  // ── Text fade animations ───────────────────────────────────────────────────
  late final Animation<double> _titleOpacity;
  late final Animation<double> _titleSlide;
  late final Animation<double> _subtitleOpacity;

  // ── Dots ───────────────────────────────────────────────────────────────────
  late final Animation<double> _dot1;
  late final Animation<double> _dot2;
  late final Animation<double> _dot3;

  // ── State ──────────────────────────────────────────────────────────────────
  String _statusText = 'Checking session…';
  bool _showDots = false;

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    // Logo pop-in (0 → 600ms)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _logoRotate = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // Float loop
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _floatY = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Text reveal (starts at 400ms)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Loading dots bounce
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _dot1 = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );
    _dot2 = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );
    _dot3 = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  Future<void> _startSequence() async {
    // Step 1: Logo pop-in
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _logoController.forward();

    // Step 2: Text reveals after logo
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _textController.forward();

    // Step 3: Show dots + status text
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _showDots = true);

    // Step 4: Check JWT token
    await Future.delayed(const Duration(milliseconds: 800));
    await _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      final token = await _storage.read(key: 'devcollab_jwt');

      if (!mounted) return;

      if (token != null && token.isNotEmpty) {
        // Token found — verify it's not expired
        final isValid = await _verifyToken(token);

        if (!mounted) return;

        if (isValid) {
          setState(() => _statusText = 'Welcome back!');
          await Future.delayed(const Duration(milliseconds: 600));
          if (!mounted) return;
          _navigateTo('/home');
        } else {
          // Token expired — clear it and go to login
          await _storage.delete(key: 'devcollab_jwt');
          await _storage.delete(key: 'devcollab_user');
          setState(() => _statusText = 'Session expired. Signing in…');
          await Future.delayed(const Duration(milliseconds: 800));
          if (!mounted) return;
          _navigateTo('/login');
        }
      } else {
        // No token — first time or logged out
        setState(() => _statusText = 'Loading…');
        await Future.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;
        _navigateTo('/login');
      }
    } catch (e) {
      // Storage error — fallback to login
      if (!mounted) return;
      setState(() => _statusText = 'Starting up…');
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      _navigateTo('/login');
    }
  }

  /// Lightweight token validation — decode JWT expiry without a full API call.
  /// For a more robust check, call GET /api/auth/me instead.
  Future<bool> _verifyToken(String token) async {
    try {
      // JWT structure: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) return false;

      // Decode base64url payload
      String payload = parts[1];
      // Add padding if needed
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }

      final decoded = String.fromCharCodes(
        base64Decode(payload.replaceAll('-', '+').replaceAll('_', '/')),
      );

      // Parse the exp claim
      final json = decoded;
      final expMatch = RegExp(r'"exp":(\d+)').firstMatch(json);
      if (expMatch == null) return true; // No exp claim = assume valid

      final exp = int.parse(expMatch.group(1)!);
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      return exp > now;
    } catch (_) {
      return false;
    }
  }

  void _navigateTo(String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _floatController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Force light status bar icons on splash
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // ── Floating logo ────────────────────────────────────────────
              AnimatedBuilder(
                animation: Listenable.merge([
                  _logoController,
                  _floatController,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatY.value),
                    child: Transform.rotate(
                      angle: _logoRotate.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Opacity(
                          opacity: _logoOpacity.value.clamp(0.0, 1.0),
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
                child: _LogoBox(),
              ),

              const SizedBox(height: 28),

              // ── App name ─────────────────────────────────────────────────
              AnimatedBuilder(
                animation: _textController,
                builder: (context, _) {
                  return Opacity(
                    opacity: _titleOpacity.value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, _titleSlide.value),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                            letterSpacing: -1.2,
                          ),
                          children: [
                            TextSpan(text: 'DevCollab'),
                            TextSpan(
                              text: '.',
                              style: TextStyle(color: Color(0xFF5B47E0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // ── Tagline ──────────────────────────────────────────────────
              AnimatedBuilder(
                animation: _textController,
                builder: (context, _) {
                  return Opacity(
                    opacity: _subtitleOpacity.value.clamp(0.0, 1.0),
                    child: const Text(
                      'Build together. Ship faster.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF888780),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              // ── Loading dots ─────────────────────────────────────────────
              if (_showDots)
                AnimatedBuilder(
                  animation: _dotsController,
                  builder: (context, _) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _Dot(offsetY: _dot1.value, color: const Color(0xFF5B47E0)),
                            const SizedBox(width: 6),
                            _Dot(offsetY: _dot2.value, color: const Color(0xFF7B6EF6)),
                            const SizedBox(width: 6),
                            _Dot(offsetY: _dot3.value, color: const Color(0xFFAFA9EC)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _statusText,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF888780),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    );
                  },
                )
              else
                const SizedBox(height: 44),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Logo box widget ─────────────────────────────────────────────────────────
class _LogoBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEDFE),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFAFA9EC), width: 0.5),
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(42, 42),
          painter: _LayerIconPainter(),
        ),
      ),
    );
  }
}

// ── Custom DevCollab layer icon ──────────────────────────────────────────────
class _LayerIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5B47E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Bottom layer
    final path1 = Path()
      ..moveTo(w * 0.08, h * 0.71)
      ..lineTo(w * 0.5, h * 0.92)
      ..lineTo(w * 0.92, h * 0.71);
    canvas.drawPath(path1, paint);

    // Middle layer
    final path2 = Path()
      ..moveTo(w * 0.08, h * 0.5)
      ..lineTo(w * 0.5, h * 0.71)
      ..lineTo(w * 0.92, h * 0.5);
    canvas.drawPath(path2, paint);

    // Top layer (closed diamond)
    final path3 = Path()
      ..moveTo(w * 0.5, h * 0.08)
      ..lineTo(w * 0.08, h * 0.29)
      ..lineTo(w * 0.5, h * 0.5)
      ..lineTo(w * 0.92, h * 0.29)
      ..close();
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Animated loading dot ─────────────────────────────────────────────────────
class _Dot extends StatelessWidget {
  final double offsetY;
  final Color color;

  const _Dot({required this.offsetY, required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}