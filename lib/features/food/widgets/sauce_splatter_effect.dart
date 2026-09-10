import 'dart:math' as math;
import 'package:flutter/material.dart';

class SauceSplatterEffect extends StatefulWidget {
  final Color sauceColor;
  final VoidCallback onComplete;

  const SauceSplatterEffect({
    super.key,
    required this.sauceColor,
    required this.onComplete,
  });

  @override
  State<SauceSplatterEffect> createState() => _SauceSplatterEffectState();
}

class _SauceSplatterEffectState extends State<SauceSplatterEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_SauceDrop> _drops;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _drops = List.generate(18, (index) {
      final angle = random.nextDouble() * 2 * math.pi;
      final distance = 40.0 + random.nextDouble() * 110.0;
      final size = 6.0 + random.nextDouble() * 14.0;
      return _SauceDrop(
        targetOffset: Offset(math.cos(angle) * distance, math.sin(angle) * distance),
        size: size,
        curveFactor: 0.5 + random.nextDouble() * 0.5,
      );
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _controller.forward().then((_) {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _controller.value;
        final opacity = (1.0 - progress).clamp(0.0, 1.0);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Center Squeeze Stream
            Transform.scale(
              scale: (1.0 + progress * 0.4),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: widget.sauceColor.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.sauceColor.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Radiating Splatter Droplets
            ..._drops.map((drop) {
              final currentOffset = Offset.lerp(
                Offset.zero,
                drop.targetOffset,
                Curves.easeOutBack.transform(progress),
              )!;

              return Transform.translate(
                offset: currentOffset,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: drop.size,
                    height: drop.size,
                    decoration: BoxDecoration(
                      color: widget.sauceColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.sauceColor.withValues(alpha: 0.35),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _SauceDrop {
  final Offset targetOffset;
  final double size;
  final double curveFactor;

  _SauceDrop({
    required this.targetOffset,
    required this.size,
    required this.curveFactor,
  });
}
