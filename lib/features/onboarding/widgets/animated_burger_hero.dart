import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A premium animated burger component featuring 6 completely distinct,
/// un-cut, individual 3D food ingredients that fly in from multiple
/// directions (top, bottom, left, right, top-left, top-right) and
/// seamlessly assemble into a delicious burger with physics and floating idle hover.
class AnimatedBurgerHero extends StatefulWidget {
  final double size;
  final bool autoPlay;
  final VoidCallback? onTap;

  const AnimatedBurgerHero({
    super.key,
    this.size = 320,
    this.autoPlay = true,
    this.onTap,
  });

  @override
  State<AnimatedBurgerHero> createState() => _AnimatedBurgerHeroState();
}

class _AnimatedBurgerHeroState extends State<AnimatedBurgerHero>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _idleFloatController;

  // Multi-directional Translation Animations (dx, dy)
  late Animation<Offset> _bottomBunOffset;
  late Animation<Offset> _bottomPattyOffset;
  late Animation<Offset> _veggiesOffset;
  late Animation<Offset> _lettuceOffset;
  late Animation<Offset> _cheesePattyOffset;
  late Animation<Offset> _topBunOffset;

  // Rotational flight dynamics
  late Animation<double> _bottomBunRotation;
  late Animation<double> _bottomPattyRotation;
  late Animation<double> _veggiesRotation;
  late Animation<double> _lettuceRotation;
  late Animation<double> _cheesePattyRotation;
  late Animation<double> _topBunRotation;

  // Opacity fade-in animations for each layer
  late Animation<double> _bottomBunOpacity;
  late Animation<double> _bottomPattyOpacity;
  late Animation<double> _veggiesOpacity;
  late Animation<double> _lettuceOpacity;
  late Animation<double> _cheesePattyOpacity;
  late Animation<double> _topBunOpacity;

  // Ambient shadow & glow bloom
  late Animation<double> _shadowBloom;
  late Animation<double> _globalScale;

  @override
  void initState() {
    super.initState();

    // 1. Multi-directional Assembly Entrance Controller
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _globalScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _shadowBloom = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
      ),
    );

    // --- Layer 6: Toasted Bottom Bun (Flies in from BOTTOM) ---
    _bottomBunOffset = Tween<Offset>(
      begin: const Offset(0, 320),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.00, 0.38, curve: Curves.easeOutBack),
      ),
    );
    _bottomBunRotation = Tween<double>(begin: 0.08, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.00, 0.38, curve: Curves.easeOut),
      ),
    );
    _bottomBunOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.00, 0.18, curve: Curves.easeIn),
      ),
    );

    // --- Layer 5: Grilled Bottom Patty (Slides in from LEFT) ---
    _bottomPattyOffset = Tween<Offset>(
      begin: const Offset(-340, 50),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.12, 0.50, curve: Curves.easeOutBack),
      ),
    );
    _bottomPattyRotation = Tween<double>(begin: -0.16, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.12, 0.50, curve: Curves.easeOut),
      ),
    );
    _bottomPattyOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.12, 0.30, curve: Curves.easeIn),
      ),
    );

    // --- Layer 4: Tomatoes, Pickles & Onions (Swoops in from RIGHT) ---
    _veggiesOffset = Tween<Offset>(
      begin: const Offset(340, -10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.24, 0.62, curve: Curves.easeOutBack),
      ),
    );
    _veggiesRotation = Tween<double>(begin: 0.18, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.24, 0.62, curve: Curves.easeOut),
      ),
    );
    _veggiesOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.24, 0.42, curve: Curves.easeIn),
      ),
    );

    // --- Layer 3: Crisp Green Lettuce (Glides from TOP-LEFT) ---
    _lettuceOffset = Tween<Offset>(
      begin: const Offset(-300, -180),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.36, 0.74, curve: Curves.easeOutBack),
      ),
    );
    _lettuceRotation = Tween<double>(begin: -0.22, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.36, 0.74, curve: Curves.easeOut),
      ),
    );
    _lettuceOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.36, 0.52, curve: Curves.easeIn),
      ),
    );

    // --- Layer 2: Melted Cheese & Patty (Slides from TOP-RIGHT) ---
    _cheesePattyOffset = Tween<Offset>(
      begin: const Offset(300, -180),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.48, 0.86, curve: Curves.easeOutBack),
      ),
    );
    _cheesePattyRotation = Tween<double>(begin: 0.20, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.48, 0.86, curve: Curves.easeOut),
      ),
    );
    _cheesePattyOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.48, 0.64, curve: Curves.easeIn),
      ),
    );

    // --- Layer 1: Golden Sesame Top Bun (Drops straight from TOP) ---
    _topBunOffset = Tween<Offset>(
      begin: const Offset(0, -360),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.60, 1.00, curve: Curves.easeOutBack),
      ),
    );
    _topBunRotation = Tween<double>(begin: -0.10, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.60, 1.00, curve: Curves.easeOut),
      ),
    );
    _topBunOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.60, 0.76, curve: Curves.easeIn),
      ),
    );

    // 2. Idle Floating physics controller
    _idleFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _entranceController.forward();
        }
      });
    } else {
      _entranceController.value = 1.0;
    }
  }

  void replayAnimation() {
    _entranceController.reset();
    _entranceController.forward();
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _idleFloatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: replayAnimation,
      child: AnimatedBuilder(
        animation: Listenable.merge([_entranceController, _idleFloatController]),
        builder: (context, child) {
          final t = _idleFloatController.value * 2 * math.pi;

          // Gentle floating wave for each layer when settled
          final isSettled = _entranceController.value > 0.85;
          final floatFactor = isSettled ? (_entranceController.value - 0.85) / 0.15 : 0.0;

          final floatTopBun = math.sin(t) * 4.0 * floatFactor;
          final floatCheesePatty = math.sin(t + 0.8) * 3.0 * floatFactor;
          final floatLettuce = math.sin(t + 1.6) * 3.5 * floatFactor;
          final floatVeggies = math.sin(t + 2.4) * 2.8 * floatFactor;
          final floatBottomPatty = math.sin(t + 3.2) * 2.4 * floatFactor;
          final floatBottomBun = math.sin(t + 4.0) * 2.0 * floatFactor;

          // Micro rotation tilt for dynamic 3D feel
          final idleTiltTop = math.sin(t * 0.8) * 0.015 * floatFactor;
          final idleTiltLettuce = math.cos(t * 0.9) * 0.018 * floatFactor;
          final idleTiltVeggies = math.sin(t * 1.1) * -0.016 * floatFactor;

          return Transform.scale(
            scale: _globalScale.value,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // 1. Ambient soft background shadow & warm glow
                  Opacity(
                    opacity: _shadowBloom.value,
                    child: Container(
                      width: widget.size * 0.72,
                      height: widget.size * 0.72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.32),
                            blurRadius: 45,
                            spreadRadius: 8,
                            offset: Offset(0, 22 + math.sin(t) * 3),
                          ),
                          BoxShadow(
                            color: const Color(0xFFFFA726).withValues(alpha: 0.12),
                            blurRadius: 55,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Layer 6: Toasted Bottom Bun (Flies from BOTTOM)
                  _buildIngredientLayer(
                    imagePath: 'assets/images/burger_components/6_bottom_bun_assembled.png',
                    offset: _bottomBunOffset.value + Offset(0, floatBottomBun),
                    rotation: _bottomBunRotation.value,
                    opacity: _bottomBunOpacity.value,
                  ),

                  // 3. Layer 5: Grilled Bottom Beef Patty (Slides from LEFT)
                  _buildIngredientLayer(
                    imagePath: 'assets/images/burger_components/5_grilled_patty_assembled.png',
                    offset: _bottomPattyOffset.value + Offset(0, floatBottomPatty),
                    rotation: _bottomPattyRotation.value,
                    opacity: _bottomPattyOpacity.value,
                  ),

                  // 4. Layer 4: Sliced Fresh Tomatoes, Pickles & Onions (Swoops from RIGHT)
                  _buildIngredientLayer(
                    imagePath: 'assets/images/burger_components/4_tomatoes_onions_assembled.png',
                    offset: _veggiesOffset.value + Offset(0, floatVeggies),
                    rotation: _veggiesRotation.value + idleTiltVeggies,
                    opacity: _veggiesOpacity.value,
                  ),

                  // 5. Layer 3: Crisp Green Salad Lettuce (Glides from TOP-LEFT)
                  _buildIngredientLayer(
                    imagePath: 'assets/images/burger_components/3_lettuce_assembled.png',
                    offset: _lettuceOffset.value + Offset(0, floatLettuce),
                    rotation: _lettuceRotation.value + idleTiltLettuce,
                    opacity: _lettuceOpacity.value,
                  ),

                  // 6. Layer 2: Melted Cheddar & Top Patty (Slides from TOP-RIGHT)
                  _buildIngredientLayer(
                    imagePath: 'assets/images/burger_components/2_cheese_patty_assembled.png',
                    offset: _cheesePattyOffset.value + Offset(0, floatCheesePatty),
                    rotation: _cheesePattyRotation.value,
                    opacity: _cheesePattyOpacity.value,
                  ),

                  // 7. Layer 1: Golden Sesame Top Bun (Drops straight from TOP)
                  _buildIngredientLayer(
                    imagePath: 'assets/images/burger_components/1_top_bun_assembled.png',
                    offset: _topBunOffset.value + Offset(0, floatTopBun),
                    rotation: _topBunRotation.value + idleTiltTop,
                    opacity: _topBunOpacity.value,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIngredientLayer({
    required String imagePath,
    required Offset offset,
    required double rotation,
    required double opacity,
  }) {
    if (opacity <= 0.001) return const SizedBox.shrink();

    return Positioned.fill(
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: offset,
          child: Transform.rotate(
            angle: rotation,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
      ),
    );
  }
}
