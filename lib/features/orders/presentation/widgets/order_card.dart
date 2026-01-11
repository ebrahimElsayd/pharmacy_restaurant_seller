import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/values_manager.dart';
import '../../domain/entities/order.dart';
import 'order_status_chip.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color based on order status
    Color statusColor;
    switch (order.status.toLowerCase()) {
      case 'pending':
        statusColor = AppPallete.pending;
        break;
      case 'processing':
        statusColor = AppPallete.processing;
        break;
      case 'shipped':
        statusColor = AppPallete.shipped;
        break;
      case 'delivered':
        statusColor = AppPallete.delivered;
        break;
      case 'cancelled':
        statusColor = AppPallete.redColor;
        break;
      case 'returned':
        statusColor = AppPallete.orangeColor;
        break;
      default:
        statusColor = AppPallete.primaryColor;
    }

    return Card(
      elevation: 3.0,
      shadowColor: statusColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        side: BorderSide(color: statusColor.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator strip at the top of the card
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ValuesManager.borderRadiusLarge),
                  topRight: Radius.circular(ValuesManager.borderRadiusLarge),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ValuesManager.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header - Basic information
                  _buildHeader(context),
                  SizedBox(height: ValuesManager.paddingMedium),

                  // Products
                  _buildProductsPreview(),
                  SizedBox(height: ValuesManager.paddingMedium),

                  // Footer - Total and Status
                  _buildFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${order.id?.substring(0, 8) ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ValuesManager.paddingSmall / 2),
              Text(
                order.customerName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppPallete.lightGreyForText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(
          '\$${order.orderTotal.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppPallete.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsPreview() {
    final items = order.items;
    if (items.isEmpty) {
      return const Text('No products');
    }

    final visibleItems = items.take(3).toList();
    final remainingCount = items.length - 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 70.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: visibleItems.length,
            separatorBuilder: (_, __) => SizedBox(width: ValuesManager.marginMedium),
            itemBuilder: (context, index) {
              final item = visibleItems[index];
              return Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: AppPallete.background,
                  borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.productName.length > 10
                                ? '${item.productName.substring(0, 10)}...'
                                : item.productName,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.quantity} x',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppPallete.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (remainingCount > 0)
          Padding(
            padding: EdgeInsets.only(top: ValuesManager.paddingSmall),
            child: Text(
              '+$remainingCount more items',
              style: const TextStyle(
                color: AppPallete.lightGreyForText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OrderStatusChip(status: order.status),
        Text(
          _formatDate(order.createdAt),
          style: const TextStyle(
            color: AppPallete.lightGreyForText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}