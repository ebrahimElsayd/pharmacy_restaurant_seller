import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/values_manager.dart';

class DashboardLoadingShimmer extends StatelessWidget {
  const DashboardLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingLarge),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: AppPallete.background,
        highlightColor: AppPallete.borderColor,
        period: const Duration(milliseconds: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Skeleton
            Container(
              height: 20.h,
              width: 150.w,
              decoration: BoxDecoration(
                color: AppPallete.background,
                borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
              ),
            ),
            SizedBox(height: ValuesManager.marginLarge),

            // Content Skeleton
            _buildContentSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSkeleton() {
    return Column(
      children: [
        // First row of cards
        Row(
          children: [
            Expanded(child: _buildSkeletonCard()),
            SizedBox(width: ValuesManager.marginMedium),
            Expanded(child: _buildSkeletonCard()),
          ],
        ),
        SizedBox(height: ValuesManager.marginMedium),

        // Second row of cards
        Row(
          children: [
            Expanded(child: _buildSkeletonCard()),
            SizedBox(width: ValuesManager.marginMedium),
            Expanded(child: _buildSkeletonCard()),
          ],
        ),
        SizedBox(height: ValuesManager.marginLarge),

        // Chart skeleton
        _buildChartSkeleton(),
      ],
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingMedium),
      decoration: BoxDecoration(
        color: AppPallete.background,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon skeleton
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: AppPallete.background,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(height: ValuesManager.marginMedium),

          // Title skeleton
          Container(
            height: 12.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: AppPallete.background,
              borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
            ),
          ),
          SizedBox(height: ValuesManager.marginSmall),

          // Value skeleton
          Container(
            height: 16.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: AppPallete.background,
              borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSkeleton() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: AppPallete.background,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
      ),
      child: Stack(
        children: [
          // Animated dots to simulate loading
          Positioned(
            left: 20.w,
            top: 20.h,
            child: _buildLoadingDots(),
          ),

          // Chart lines skeleton
          Positioned.fill(
            child: CustomPaint(
              painter: _ChartSkeletonPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.only(left: index > 0 ? 8.w : 0),
          child: _AnimatedDot(delay: Duration(milliseconds: index * 200)),
        );
      }),
    );
  }
}

class _AnimatedDot extends StatefulWidget {
  final Duration delay;

  const _AnimatedDot({required this.delay});

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
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
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: AppPallete.primaryColor.withOpacity(_animation.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class _ChartSkeletonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppPallete.borderColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Draw skeleton chart lines
    final points = [
      Offset(size.width * 0.1, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.7, size.height * 0.7),
      Offset(size.width * 0.9, size.height * 0.3),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw skeleton dots
    final dotPaint = Paint()
      ..color = AppPallete.borderColor
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}