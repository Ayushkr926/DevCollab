import 'package:flutter/material.dart';

class LoadingSkeleton extends StatefulWidget {
  final int count;
  const LoadingSkeleton({super.key, this.count = 6});

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: widget.count,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: _ShimmerCard(controller: _ctrl),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final AnimationController controller;
  const _ShimmerCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200;
    final highlight = isDark ? Colors.white.withOpacity(0.12) : Colors.grey.shade100;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ShaderMask(
          shaderCallback: (rect) {
            final dx = controller.value * 2 - 1;
            return LinearGradient(
              begin: Alignment(-1 + dx, 0),
              end: Alignment(0 + dx, 0),
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(rect);
          },
          child: Container(
            height: 188,
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.circular(26),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 14, width: 130, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(height: 12, width: 90, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(height: 40, width: double.infinity, color: Colors.white),
                const Spacer(),
                Row(
                  children: [
                    Expanded(child: Container(height: 40, color: Colors.white)),
                    const SizedBox(width: 10),
                    Expanded(child: Container(height: 40, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
