import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_restaurant_seller/features/orders/presentation/screens/orders_list_screen.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'icon': Icons.shopping_cart_outlined,
        'label': 'Orders',
        'subtitle': 'Manage Orders',
        'gradient': const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'onTap': () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => OrdersListScreen()),
        ),
      },
      {
        'icon': Icons.inventory_2_outlined,
        'label': 'Products',
        'subtitle': 'Add & Edit',
        'gradient': const LinearGradient(
          colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'onTap': () => _navigateToProducts(context),
      },
      {
        'icon': Icons.analytics_outlined,
        'label': 'Analytics',
        'subtitle': 'Stats & Reports',
        'gradient': const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'onTap': () => _navigateToAnalytics(context),
      },
      {
        'icon': Icons.store_outlined,
        'label': 'Store Management',
        'subtitle': 'General Settings',
        'gradient': const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'onTap': () => _navigateToStoreManagement(context),
      },
    ];

    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingLarge),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s18,
                    color: AppPallete.blackForText,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(ValuesManager.paddingSmall),
                  decoration: BoxDecoration(
                    color: AppPallete.primaryLight,
                    borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                  ),
                  child: Icon(
                    Icons.flash_on,
                    color: AppPallete.primaryColor,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: ValuesManager.marginLarge),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: ValuesManager.marginMedium,
              mainAxisSpacing: ValuesManager.marginMedium,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2, // Increased from 1.1 to give more height
              children: actions.map((action) {
                return _ActionCard(
                  icon: action['icon'] as IconData,
                  label: action['label'] as String,
                  subtitle: action['subtitle'] as String,
                  gradient: action['gradient'] as LinearGradient,
                  onTap: action['onTap'] as VoidCallback,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProducts(BuildContext context) {
    print('Navigate to Products screen');
  }

  void _navigateToAnalytics(BuildContext context) {
    print('Navigate to Analytics screen');
  }

  void _navigateToStoreManagement(BuildContext context) {
    print('Navigate to Store Management');
  }
}

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.colors.first.withValues(alpha: 0.3),
                    blurRadius: _isPressed ? 10 : 15,
                    offset: Offset(0, _isPressed ? 4 : 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(ValuesManager.paddingMedium), // Reduced from paddingLarge
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Added to prevent column from taking full height
                    children: [
                      Container(
                        padding: EdgeInsets.all(ValuesManager.paddingSmall),
                        decoration: BoxDecoration(
                          color: AppPallete.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                        ),
                        child: Icon(
                          widget.icon,
                          color: AppPallete.white,
                          size: 20.sp, // Reduced from 24.sp
                        ),
                      ),
                      SizedBox(height: ValuesManager.marginSmall), // Reduced from marginMedium
                      Flexible( // Added Flexible to prevent text overflow
                        child: Text(
                          widget.label,
                          style: const TextStyle(
                            color: AppPallete.white,
                            fontSize: FontSize.s12, // Reduced from s14
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: ValuesManager.marginSmall / 3), // Further reduced spacing
                      Flexible( // Added Flexible to prevent text overflow
                        child: Text(
                          widget.subtitle,
                          style: TextStyle(
                            color: AppPallete.white.withValues(alpha: 0.8),
                            fontSize: FontSize.s8, // Reduced from s12
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}