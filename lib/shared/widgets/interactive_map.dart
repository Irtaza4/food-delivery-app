import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';

class InteractiveTrackingMap extends StatefulWidget {
  final double height;
  final String estimatedTime;

  const InteractiveTrackingMap({
    super.key,
    this.height = 360,
    this.estimatedTime = '5-10 min',
  });

  @override
  State<InteractiveTrackingMap> createState() => _InteractiveTrackingMapState();
}

class _InteractiveTrackingMapState extends State<InteractiveTrackingMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      color: const Color(0xFFF1F3F5),
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          final progress = 0.35 + (_animController.value * 0.3); // moving courier along route
          return Stack(
            children: [
              // Custom map graphics background with street vectors
              CustomPaint(
                size: Size(double.infinity, widget.height),
                painter: _MapPainter(progress: progress),
              ),

              // Restaurant Marker (Top Right Start)
              Positioned(
                top: 70,
                right: 90,
                child: _buildPin(
                  icon: Icons.restaurant,
                  color: AppColors.primary,
                  label: 'Kitchen',
                ),
              ),

              // Courier / Bike Marker (Moving along path)
              Positioned(
                left: 60 + (progress * 130),
                top: 130 + (math.sin(progress * math.pi) * 60),
                child: _buildCourierMarker(),
              ),

              // Destination House Pin (Bottom Center)
              Positioned(
                bottom: 60,
                right: 70,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Floating "Estimated Time 5-10 min" bubble
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppTheme.floatingShadow,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Estimated Time',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.estimatedTime,
                            style: AppTypography.heading3.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Blue destination pulse dot
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2563EB),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCourierMarker() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        shape: BoxShape.circle,
        boxShadow: AppTheme.floatingShadow,
        border: Border.all(color: Colors.white, width: 2.5),
      ),
      child: const Center(
        child: Icon(
          Icons.delivery_dining_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildPin({required IconData icon, required Color color, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: AppTheme.cardShadow,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  final double progress;

  _MapPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Background street grid lines
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw some background street lines
    canvas.drawLine(const Offset(0, 80), Offset(size.width, 100), roadPaint);
    canvas.drawLine(const Offset(40, 0), Offset(60, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.65, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.55), roadPaint);

    // Minor streets
    canvas.drawLine(const Offset(0, 180), Offset(size.width * 0.5, 200), minorRoadPaint);
    canvas.drawLine(Offset(size.width * 0.4, 120), Offset(size.width, 180), minorRoadPaint);
    canvas.drawLine(const Offset(120, 0), Offset(180, size.height), minorRoadPaint);


    // Active red delivery route path matching the screenshot
    final routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final routePath = Path();
    // Start at restaurant (top right)
    routePath.moveTo(size.width - 95, 85);
    // Path turns down and left
    routePath.lineTo(size.width - 100, 130);
    routePath.lineTo(size.width * 0.55, 170);
    routePath.lineTo(size.width * 0.35, 150);
    routePath.lineTo(80, 145);
    routePath.lineTo(95, 220);
    routePath.lineTo(size.width * 0.6, 250);
    routePath.lineTo(size.width - 80, 240);
    routePath.lineTo(size.width - 70, size.height - 70);

    canvas.drawPath(routePath, routePaint);
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => oldDelegate.progress != progress;
}
