import 'package:flutter/material.dart';

enum SlideDirection {
  fromTop,
  fromBottom,
  fromLeft,
  fromRight,
  none,
}

class AnimatedEntry extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final SlideDirection direction;
  final double distance;
  final Curve curve;
  final bool enableScale;
  final double startScale;

  const AnimatedEntry({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 550),
    this.direction = SlideDirection.fromBottom,
    this.distance = 0.25,
    this.curve = Curves.easeOutCubic,
    this.enableScale = false,
    this.startScale = 0.92,
  });

  @override
  State<AnimatedEntry> createState() => _AnimatedEntryState();
}

class _AnimatedEntryState extends State<AnimatedEntry> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curved);

    Offset startOffset;
    switch (widget.direction) {
      case SlideDirection.fromTop:
        startOffset = Offset(0.0, -widget.distance);
        break;
      case SlideDirection.fromBottom:
        startOffset = Offset(0.0, widget.distance);
        break;
      case SlideDirection.fromLeft:
        startOffset = Offset(-widget.distance, 0.0);
        break;
      case SlideDirection.fromRight:
        startOffset = Offset(widget.distance, 0.0);
        break;
      case SlideDirection.none:
        startOffset = Offset.zero;
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: startOffset,
      end: Offset.zero,
    ).animate(curved);

    _scaleAnimation = Tween<double>(
      begin: widget.enableScale ? widget.startScale : 1.0,
      end: 1.0,
    ).animate(curved);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.enableScale
            ? ScaleTransition(
                scale: _scaleAnimation,
                child: widget.child,
              )
            : widget.child,
      ),
    );
  }
}
