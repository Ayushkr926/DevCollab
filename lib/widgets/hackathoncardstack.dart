import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/Hackathinmodel.dart';

class HackathonCardStack extends StatefulWidget {
  final List<Hackathon> hackathons;
  final double? cardWidth;
  final double cardHeight;
  final void Function(Hackathon)? onRegister;

  const HackathonCardStack({
    super.key,
    required this.hackathons,
    this.cardWidth,
    this.cardHeight = 250,
    this.onRegister,
  });

  @override
  State<HackathonCardStack> createState() => _HackathonCardStackState();
}

class _HackathonCardStackState extends State<HackathonCardStack>
    with TickerProviderStateMixin {
  int _index = 0;

  late AnimationController _exitCtrl;
  late AnimationController _entryCtrl;
  late AnimationController _dragCtrl;

  late Animation<Offset> _slideOut;
  late Animation<double> _entryScale;
  late Animation<double> _entryOpacity;
  late Animation<double> _entryLift; // New subtle lift animation

  Offset _dragOffset = Offset.zero;
  double _dragRotationValue = 0.0;
  bool _isDragging = false;

  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 580),
    );

    _dragCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..addListener(() {
      setState(() {
        _dragOffset = Offset.lerp(_dragOffset, Offset.zero, _dragCtrl.value)!;
        _dragRotationValue *= (1 - _dragCtrl.value);
      });
    });

    // ── New Smoother Exit Animation (more natural diagonal swipe) ──
    _slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(2.8, -0.35),
    ).animate(CurvedAnimation(
      parent: _exitCtrl,
      curve: Curves.easeOutExpo, // Very smooth & snappy
    ));

    // ── Enhanced Entry Animation (gentle pop + lift) ──
    _entryScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutBack),
    );

    _entryOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
    );

    _entryLift = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic),
    );

    _entryCtrl.forward();
    _startAutoTimer();
  }

  void _startAutoTimer() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (mounted && !_isDragging && !_exitCtrl.isAnimating) {
        _goNext();
      }
    });
  }

  @override
  void dispose() {
    _exitCtrl.dispose();
    _entryCtrl.dispose();
    _dragCtrl.dispose();
    _autoTimer?.cancel();
    super.dispose();
  }

  int get _count => widget.hackathons.length;

  Future<void> _goNext() async {
    if (_exitCtrl.isAnimating || _count == 0) return;
    HapticFeedback.mediumImpact();

    await _exitCtrl.forward();
    setState(() {
      _index = (_index + 1) % _count;
      _dragOffset = Offset.zero;
      _dragRotationValue = 0;
    });
    _exitCtrl.reset();
    _entryCtrl.reset();
    _entryCtrl.forward();
  }

  Future<void> _goPrev() async {
    if (_count == 0) return;
    HapticFeedback.mediumImpact();

    setState(() {
      _index = (_index - 1 + _count) % _count;
      _dragOffset = Offset.zero;
      _dragRotationValue = 0;
    });
    _entryCtrl.reset();
    _entryCtrl.forward();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_exitCtrl.isAnimating) return;
    setState(() {
      _isDragging = true;
      _dragOffset += details.delta;
      _dragRotationValue = _dragOffset.dx / 160; // Smoother rotation
    });
  }

  void _onDragEnd(DragEndDetails details) {
    _isDragging = false;
    final velocity = details.velocity.pixelsPerSecond.dx;
    final distance = _dragOffset.dx.abs();

    if (distance > 140 || velocity.abs() > 500) {
      final isRightSwipe = _dragOffset.dx > 0 || velocity > 0;
      HapticFeedback.heavyImpact();

      _exitCtrl.forward().then((_) {
        setState(() {
          _index = isRightSwipe
              ? (_index + 1) % _count
              : (_index - 1 + _count) % _count;
        });
        _resetAfterSwipe();
      });
    } else {
      _dragCtrl.forward(from: 0); // Smooth snap back
      HapticFeedback.selectionClick();
    }
  }

  void _resetAfterSwipe() {
    _exitCtrl.reset();
    _entryCtrl.reset();
    _dragOffset = Offset.zero;
    _dragRotationValue = 0;
    _entryCtrl.forward();
    _startAutoTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hackathons.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(builder: (context, constraints) {
      final width = widget.cardWidth ?? constraints.maxWidth;
      final height = widget.cardHeight;

      return SizedBox(
        width: width,
        child: Column(
          children: [

            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              height: height,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  ..._peekCards(width),
                  _mainCard(width, height),
                ],
              ),
            ),
            // _navRow(),
          ],
        ),
      );
    });
  }

  List<Widget> _peekCards(double w) {
    final List<Widget> out = [];
    for (int i = 2; i >= 1; i--) {
      final hack = widget.hackathons[(_index + i) % _count];
      out.add(
        Positioned(
          top: i * 11.0,
          child: Transform.scale(
            scale: 0.95 - i * 0.07,
            child: Opacity(
              opacity: 0.78 - i * 0.32,
              child: Container(
                width: w,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: hack.accentColor!.withOpacity(0.15),
                    width: 1.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 22,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return out;
  }

  Widget _mainCard(double w, double h) {
    final hack = widget.hackathons[_index];

    return Positioned(
      top: 0,
      child: GestureDetector(
        onHorizontalDragCancel: () => setState(() => _isDragging = false),
        child: AnimatedBuilder(
          animation: Listenable.merge([_exitCtrl, _entryCtrl, _dragCtrl]),
          builder: (ctx, child) {
            final slide = _exitCtrl.isAnimating ? _slideOut.value : _dragOffset;
            final rot = _exitCtrl.isAnimating
                ? 0.0
                : _dragRotationValue * (math.pi / 11);

            final lift = _entryLift.value;

            return Transform.translate(
              offset: slide + Offset(0, lift),
              child: Transform.rotate(
                angle: rot,
                child: ScaleTransition(
                  scale: _entryScale,
                  child: FadeTransition(
                    opacity: _entryOpacity,
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: _CardContent(
            hack: hack,
            width: w,
            height: h,
            onRegister: widget.onRegister,
          ),
        ),
      ),
    );
  }

  Widget _navRow() {
    final accent = widget.hackathons[_index].accentColor ?? Colors.deepPurple;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _navBtn(Icons.arrow_back_ios_new_rounded, _goPrev,
            const Color(0xFF2A2A40), const Color(0xFFAAAAAA)),
        const SizedBox(width: 24),
        ...List.generate(_count, (i) {
          final active = i == _index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? accent : const Color(0xFF3A3A52),
              borderRadius: BorderRadius.circular(6),
              boxShadow: active
                  ? [BoxShadow(color: accent.withOpacity(0.6), blurRadius: 10)]
                  : null,
            ),
          );
        }),
        const SizedBox(width: 24),
        _navBtn(Icons.arrow_forward_ios_rounded, _goNext, accent, Colors.white),
      ],
    );
  }

  Widget _navBtn(
      IconData icon, VoidCallback onTap, Color bg, Color iconColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}

// ─── Card Content (Restored & Clean) ───────────────────────────────────────
class _CardContent extends StatelessWidget {
  final Hackathon hack;
  final double width;
  final double height;
  final void Function(Hackathon)? onRegister;

  const _CardContent({
    super.key,
    required this.hack,
    required this.width,
    required this.height,
    this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final accent = hack.accentColor ?? Colors.deepPurple;

    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1C1C30),
            Color.lerp(const Color(0xFF1C1C30), accent, 0.18)!,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: accent.withOpacity(0.5), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.28),
            blurRadius: 35,
            spreadRadius: -10,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned(top: -70, right: -60, child: _blob(190, accent, 0.09)),
            Positioned(bottom: -50, left: -40, child: _blob(150, accent, 0.07)),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _iconBox(accent),
                      const Spacer(),
                      _modeBadge(hack, accent),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hack.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      height: 1.05,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 18),
                  _countdownBlock(hack, accent),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blob(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
      ),
    );
  }

  Widget _iconBox(Color accent) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: accent.withOpacity(0.15),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: accent.withOpacity(0.3)),
    ),
    child: Icon(Icons.rocket_launch, color: accent, size: 26),
  );

  Widget _modeBadge(Hackathon hack, Color accent) {
    final isOnline = hack.isOnline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: accent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.wifi : Icons.location_on,
            size: 14,
            color: accent,
          ),
          const SizedBox(width: 5),
          Text(
            isOnline ? "Online" : "Offline",
            style: TextStyle(
              color: accent,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _countdownBlock(Hackathon hack, Color accent) {
    final now = DateTime.now();
    final diff = hack.hackathonStart.difference(now);
    final days = diff.isNegative ? 0 : diff.inDays;
    final hours = diff.isNegative ? 0 : diff.inHours.remainder(24);
    final minutes = diff.isNegative ? 0 : diff.inMinutes.remainder(60);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3A3A52)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _countUnit(days.toString().padLeft(2, '0'), 'DAYS', accent),
          _divider(),
          _countUnit(hours.toString().padLeft(2, '0'), 'HRS', accent),
          _divider(),
          _countUnit(minutes.toString().padLeft(2, '0'), 'MIN', accent),
        ],
      ),
    );
  }

  Widget _countUnit(String val, String label, Color accent) => Column(
    children: [
      Text(
        val,
        style: TextStyle(
          color: accent,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
      Text(
        label,
        style: const TextStyle(
          color: Color(0xFF7777AA),
          fontSize: 10,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );

  Widget _divider() => const Text(
    ':',
    style: TextStyle(
      color: Color(0xFF444466),
      fontSize: 26,
      fontWeight: FontWeight.w300,
    ),
  );

  Widget _registerButton(Hackathon hack, Color accent) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.45),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Text(
          'Register →',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}