import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/models/burger_ingredient.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'sauce_splatter_effect.dart';

class BurgerStackCanvas extends StatefulWidget {
  final List<BurgerIngredient> layers;
  final bool isExploded;
  final bool showLabels;
  final Function(int index) onRemoveLayer;
  final VoidCallback onAddTopBun;
  final bool hasTopBun;
  final Color? activeSauceSplatter;
  final VoidCallback onSauceSplatterComplete;

  const BurgerStackCanvas({
    super.key,
    required this.layers,
    required this.isExploded,
    required this.showLabels,
    required this.onRemoveLayer,
    required this.onAddTopBun,
    required this.hasTopBun,
    this.activeSauceSplatter,
    required this.onSauceSplatterComplete,
  });

  @override
  State<BurgerStackCanvas> createState() => _BurgerStackCanvasState();
}

class _BurgerStackCanvasState extends State<BurgerStackCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _idleFloatController;

  @override
  void initState() {
    super.initState();
    _idleFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _idleFloatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxHeight = constraints.maxHeight;
        final double maxWidth = constraints.maxWidth;

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Platter Shadow & Base Glow
            Positioned(
              bottom: widget.isExploded ? 25 : 35,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                width: widget.isExploded ? 260 : 240,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.elliptical(260, 32)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: widget.isExploded ? 0.2 : 0.45),
                      blurRadius: widget.isExploded ? 24 : 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 36,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Wooden Platter Plate
            Positioned(
              bottom: widget.isExploded ? 20 : 30,
              child: Container(
                width: 270,
                height: 26,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF966038), Color(0xFF633D20), Color(0xFF381F0F)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.all(Radius.elliptical(270, 26)),
                  border: Border.all(color: const Color(0xFFB57D4F), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),

            // Burger Layers Stack
            AnimatedBuilder(
              animation: _idleFloatController,
              builder: (context, child) {
                final floatOffset = math.sin(_idleFloatController.value * math.pi * 2) * 3.0;

                return Transform.translate(
                  offset: Offset(0, floatOffset),
                  child: _buildLayersStack(maxHeight, maxWidth),
                );
              },
            ),

            // Active Sauce Splatter Overlay
            if (widget.activeSauceSplatter != null)
              Positioned(
                top: maxHeight * 0.35,
                child: SauceSplatterEffect(
                  sauceColor: widget.activeSauceSplatter!,
                  onComplete: widget.onSauceSplatterComplete,
                ),
              ),

            // Top Bun Prompt Pill (if burger not yet closed)
            if (!widget.hasTopBun && widget.layers.length > 1)
              Positioned(
                top: 15,
                child: GestureDetector(
                  onTap: widget.onAddTopBun,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF7A00), Color(0xFFFF4800)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF5722).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_downward_rounded, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Tap to Close Crown Bun 🥯',
                          style: AppTypography.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLayersStack(double maxHeight, double maxWidth) {
    final int count = widget.layers.length;
    if (count == 0) return const SizedBox.shrink();

    // Calculate total height needed for assembled mode
    double rawTotalHeight = 0;
    for (int i = 0; i < count; i++) {
      rawTotalHeight += widget.layers[i].layerHeight;
    }

    // Auto-scale if burger is huge (e.g. 10+ layers)
    final double maxUsableHeight = maxHeight * 0.70;
    final double scale = widget.isExploded
        ? 0.90
        : (rawTotalHeight > maxUsableHeight ? (maxUsableHeight / rawTotalHeight) : 1.0);

    // Exploded spacing
    final double explodedSpacing = (maxHeight * 0.72) / math.max(count, 1);

    // Calculate bottom offsets for each layer
    final List<double> bottomOffsets = [];
    double cumulativeBottom = 42.0; // Base platter height offset

    for (int i = 0; i < count; i++) {
      if (widget.isExploded) {
        bottomOffsets.add(35.0 + (i * explodedSpacing));
      } else {
        bottomOffsets.add(cumulativeBottom);
        cumulativeBottom += widget.layers[i].layerHeight * scale;
      }
    }

    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: List.generate(count, (index) {
          final ingredient = widget.layers[index];
          final isTop = index == count - 1;
          final bottomPos = bottomOffsets[index];

          return AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            bottom: bottomPos,
            child: _AnimatedBurgerLayerItem(
              key: ValueKey('layer_${ingredient.id}_$index'),
              ingredient: ingredient,
              index: index,
              isTop: isTop,
              isExploded: widget.isExploded,
              showLabel: widget.showLabels || widget.isExploded,
              scale: scale,
              onRemove: () => widget.onRemoveLayer(index),
            ),
          );
        }),
      ),
    );
  }
}

class _AnimatedBurgerLayerItem extends StatefulWidget {
  final BurgerIngredient ingredient;
  final int index;
  final bool isTop;
  final bool isExploded;
  final bool showLabel;
  final double scale;
  final VoidCallback onRemove;

  const _AnimatedBurgerLayerItem({
    super.key,
    required this.ingredient,
    required this.index,
    required this.isTop,
    required this.isExploded,
    required this.showLabel,
    required this.scale,
    required this.onRemove,
  });

  @override
  State<_AnimatedBurgerLayerItem> createState() => _AnimatedBurgerLayerItemState();
}

class _AnimatedBurgerLayerItemState extends State<_AnimatedBurgerLayerItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _dropController;
  late Animation<double> _dropAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _dropAnimation = Tween<double>(begin: -100.0, end: 0.0).animate(
      CurvedAnimation(parent: _dropController, curve: Curves.elasticOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.25, end: 1.0).animate(
      CurvedAnimation(parent: _dropController, curve: Curves.easeOutBack),
    );

    // Subtle natural tilt
    final double targetRotation = ((widget.index % 4) - 1.5) * 0.012;
    _rotationAnimation = Tween<double>(begin: 0.05, end: targetRotation).animate(
      CurvedAnimation(parent: _dropController, curve: Curves.easeOut),
    );

    _dropController.forward();
  }

  @override
  void dispose() {
    _dropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic layer dimensions matching horizontal wide aspect ratio
    final double layerWidth = (widget.ingredient.isTopBun ? 260.0 : (widget.ingredient.isBottomBun ? 250.0 : 255.0)) * widget.scale;
    final double layerHeight = (widget.ingredient.isTopBun ? 95.0 : (widget.ingredient.isBottomBun ? 65.0 : 68.0)) * widget.scale;

    return AnimatedBuilder(
      animation: _dropController,
      builder: (context, child) {
        final double dropY = _dropAnimation.value;
        final double dropScale = _scaleAnimation.value;
        final double rot = _rotationAnimation.value;

        return Transform.translate(
          offset: Offset(0, dropY),
          child: Transform.rotate(
            angle: rot,
            child: Transform.scale(
              scale: dropScale,
              child: GestureDetector(
                onTap: () {
                  if (!widget.ingredient.isBottomBun) {
                    widget.onRemove();
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Wide Horizontal Ingredient Layer Image
                    SizedBox(
                      width: layerWidth,
                      height: layerHeight,
                      child: Image.asset(
                        widget.ingredient.image,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                    ),

                    // Exploded / Inspector Badge
                    if (widget.showLabel && !widget.ingredient.isBottomBun)
                      Positioned(
                        right: -70,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: widget.showLabel ? 1.0 : 0.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: widget.ingredient.colorAccent.withValues(alpha: 0.8),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(widget.ingredient.emoji, style: const TextStyle(fontSize: 10)),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.ingredient.name.length > 15
                                          ? '${widget.ingredient.name.substring(0, 13)}...'
                                          : widget.ingredient.name,
                                      style: AppTypography.caption.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '+\$${widget.ingredient.price.toStringAsFixed(2)}',
                                      style: AppTypography.caption.copyWith(
                                        color: const Color(0xFF22C55E),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 9,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${widget.ingredient.calories} kcal',
                                      style: AppTypography.caption.copyWith(
                                        color: Colors.white70,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Quick Remove "X" Pill on hover/tap if in exploded view
                    if (widget.isExploded && !widget.ingredient.isBottomBun)
                      Positioned(
                        left: -35,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 15),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
