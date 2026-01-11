import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../../domain/entitise/top_product.dart';

class TopProductsWidget extends StatelessWidget {
  final List<TopProduct>? products;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;

  const TopProductsWidget({
    super.key,
    required this.products,
    required this.isLoading,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && (products == null || products!.isEmpty)) {
      return const _ProductsSkeleton();
    }

    if (error != null) {
      return _ErrorState(
        message: error!,
        onRetry: onRetry,
      );
    }

    if (products == null || products!.isEmpty) {
      return _EmptyState(
        onRetry: onRetry,
      );
    }

    return _ProductsContent(products: products!);
  }
}

class _ProductsContent extends StatelessWidget {
  final List<TopProduct> products;

  const _ProductsContent({required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingLarge),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Selling Products',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s18,
                  color: AppPallete.blackForText,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ValuesManager.paddingMedium,
                  vertical: ValuesManager.paddingSmall,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  ),
                  borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: AppPallete.white,
                      size: 14.sp,
                    ),
                    SizedBox(width: ValuesManager.marginSmall / 2),
                    const Text(
                      'Top',
                      style: TextStyle(
                        color: AppPallete.white,
                        fontSize: FontSize.s12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ValuesManager.marginLarge),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length > 5 ? 5 : products.length,
            separatorBuilder: (_, __) => SizedBox(height: ValuesManager.marginMedium),
            itemBuilder: (context, index) {
              final product = products[index];
              return _ProductItem(
                product: product,
                index: index,
              );
            },
          ),
          if (products.length > 5) ...[
            SizedBox(height: ValuesManager.marginMedium),
            Center(
              child: TextButton(
                onPressed: () {
                  // Show all products
                  print('Show all products');
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppPallete.primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: ValuesManager.paddingLarge,
                    vertical: ValuesManager.paddingSmall,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: FontSize.s14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: ValuesManager.marginSmall),
                    Icon(
                      Icons.arrow_back_ios,
                      size: 14.sp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final TopProduct product;
  final int index;

  const _ProductItem({
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final (gradient, icon) = _getRankInfo(index);

    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingMedium),
      decoration: BoxDecoration(
        color: AppPallete.background,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
        border: Border.all(
          color: AppPallete.borderColor,
        ),
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withAlpha((0.3 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: index < 3
                  ? Icon(
                icon,
                color: AppPallete.white,
                size: 18.sp,
              )
                  : Text(
                '${index + 1}',
                style: const TextStyle(
                  color: AppPallete.white,
                  fontSize: FontSize.s12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: ValuesManager.marginMedium),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: FontSize.s14,
                    color: AppPallete.blackForText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ValuesManager.marginSmall / 2),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ValuesManager.paddingSmall,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppPallete.secondaryLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${product.sales} sales',
                        style: const TextStyle(
                          color: AppPallete.secondary,
                          fontSize: FontSize.s12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: ValuesManager.marginSmall),
                    Icon(
                      Icons.circle,
                      size: 4.sp,
                      color: AppPallete.lightGreyForText,
                    ),
                    SizedBox(width: ValuesManager.marginSmall),
                    Text(
                      '${product.revenue.toStringAsFixed(0)} SAR',
                      style: const TextStyle(
                        color: AppPallete.lightGreyForText,
                        fontSize: FontSize.s12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Progress Indicator
          Container(
            width: 40.w,
            child: Column(
              children: [
                Text(
                  '#${product.rank}',
                  style: TextStyle(
                    color: gradient.colors.first,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s12,
                  ),
                ),
                SizedBox(height: ValuesManager.marginSmall / 2),
                LinearProgressIndicator(
                  value: (product.sales / 100).clamp(0.0, 1.0),
                  backgroundColor: AppPallete.borderColor,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(gradient.colors.first),
                  minHeight: 3.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (LinearGradient, IconData) _getRankInfo(int index) {
    switch (index) {
      case 0:
        return (
        const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        Icons.emoji_events
        );
      case 1:
        return (
        const LinearGradient(
          colors: [Color(0xFFC0C0C0), Color(0xFF808080)],
        ),
        Icons.workspace_premium
        );
      case 2:
        return (
        const LinearGradient(
          colors: [Color(0xFFCD7F32), Color(0xFF8B4513)],
        ),
        Icons.workspace_premium_outlined
        );
      default:
        return (
        const LinearGradient(
          colors: [Color(0xFF6B7280), Color(0xFF4B5563)],
        ),
        Icons.star_outline
        );
    }
  }
}

class _ProductsSkeleton extends StatelessWidget {
  const _ProductsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingLarge),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Selling Products',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.s18,
              color: AppPallete.blackForText,
            ),
          ),
          SizedBox(height: ValuesManager.marginLarge),
          ...List.generate(5, (index) {
            return Container(
              margin: EdgeInsets.only(bottom: ValuesManager.marginMedium),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppPallete.background,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(AppPallete.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(width: ValuesManager.marginMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppPallete.background,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: ValuesManager.marginSmall),
                        Container(
                          height: 12.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: AppPallete.background,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorState({
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingLarge),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(ValuesManager.paddingLarge),
            decoration: BoxDecoration(
              color: AppPallete.redLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              color: AppPallete.redColor,
              size: 32.sp,
            ),
          ),
          SizedBox(height: ValuesManager.marginMedium),
          const Text(
            'Error Occurred',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.s16,
              color: AppPallete.blackForText,
            ),
          ),
          SizedBox(height: ValuesManager.marginSmall),
          Text(
            message,
            style: const TextStyle(
              color: AppPallete.lightGreyForText,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: ValuesManager.marginLarge),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.primaryColor,
                foregroundColor: AppPallete.white,
                padding: EdgeInsets.symmetric(
                  horizontal: ValuesManager.paddingLarge,
                  vertical: ValuesManager.paddingMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback? onRetry;

  const _EmptyState({this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingLarge),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(ValuesManager.paddingLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPallete.lightGreyForText.withAlpha((0.1 * 255).toInt()),
                  AppPallete.lightGreyForText.withAlpha((0.05 * 255).toInt()),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: AppPallete.lightGreyForText.withAlpha((0.5 * 255).toInt()),
              size: 32.sp,
            ),
          ),
          SizedBox(height: ValuesManager.marginMedium),
          const Text(
            'No Products Available',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.s16,
              color: AppPallete.blackForText,
            ),
          ),
          SizedBox(height: ValuesManager.marginSmall),
          const Text(
            'Top selling products will appear here once orders are received',
            style: TextStyle(
              color: AppPallete.lightGreyForText,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: ValuesManager.marginLarge),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.primaryColor,
                foregroundColor: AppPallete.white,
                padding: EdgeInsets.symmetric(
                  horizontal: ValuesManager.paddingLarge,
                  vertical: ValuesManager.paddingMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      ValuesManager.borderRadius),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
