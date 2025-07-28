
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../providers/order_details_notifier.dart';
import '../providers/order_details_state.dart';
import '../providers/orders_notifier.dart';
import '../providers/usecases_providers.dart';
import '../widgets/customer_info.dart';
import '../widgets/order_summary.dart';
import '../widgets/order_timeline.dart';
import '../widgets/orders_empty_state.dart';
import '../widgets/products_list.dart';

// Simple update functions without provider
class OrderStatusUpdater {
  static Future<void> updateStatus(WidgetRef ref, String orderId, String status) async {
    try {
      final updateStatusUseCase = ref.read(updateOrderStatusProvider);
      final result = await updateStatusUseCase(orderId, status);

      result.fold(
            (failure) => throw Exception(failure.toString()),
            (_) {
          // Force refresh the order details after successful update
          ref.invalidate(orderDetailsNotifierProvider(orderId));
          // Also refresh the orders list if available
          ref.invalidate(ordersNotifierProvider);
        },
      );
    } catch (e) {
      throw Exception('Failed to update status: ${e.toString()}');
    }
  }

  static Future<void> updateNotes(WidgetRef ref, String orderId, String notes) async {
    try {
      final updateNotesUseCase = ref.read(updateOrderNotesProvider);
      final result = await updateNotesUseCase(orderId, notes);

      result.fold(
            (failure) => throw Exception(failure.toString()),
            (_) {
          // Force refresh the order details after successful update
          ref.invalidate(orderDetailsNotifierProvider(orderId));
          // Also refresh the orders list if available
          ref.invalidate(ordersNotifierProvider);
        },
      );
    } catch (e) {
      throw Exception('Failed to update notes: ${e.toString()}');
    }
  }

  static Future<void> updateDeliveryDate(WidgetRef ref, String orderId, DateTime date) async {
    try {
      final updateDateUseCase = ref.read(updateExpectedDeliveryDateProvider);
      final result = await updateDateUseCase(orderId, date);

      result.fold(
            (failure) => throw Exception(failure.toString()),
            (_) {
          // Force refresh the order details after successful update
          ref.invalidate(orderDetailsNotifierProvider(orderId));
          // Also refresh the orders list if available
          ref.invalidate(ordersNotifierProvider);
        },
      );
    } catch (e) {
      throw Exception('Failed to update delivery date: ${e.toString()}');
    }
  }
}

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderDetailsState = ref.watch(orderDetailsNotifierProvider(orderId));

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: _buildAppBar(context),
      body: _buildContent(orderDetailsState, ref, context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Order Details',
        style: TextStyle(
          fontSize: FontSize.s20,
          fontWeight: FontWeight.bold,
          color: AppPallete.blackForText,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppPallete.white,
      foregroundColor: AppPallete.blackForText,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppPallete.background,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Icon(Icons.arrow_back, size: 20),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: ValuesManager.marginMedium),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                icon: Icons.share_rounded,
                onPressed: () => _shareInvoice(context),
                color: AppPallete.blueColor,
              ),
              SizedBox(width: ValuesManager.marginSmall),
              _buildActionButton(
                icon: Icons.print_rounded,
                onPressed: () => _printInvoice(context),
                color: AppPallete.primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      width: AppSize.s40,
      height: AppSize.s40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 20.sp),
        padding: EdgeInsets.all(8.w),
        constraints: BoxConstraints(
          minWidth: 40.w,
          minHeight: 40.h,
        ),
      ),
    );
  }

  Widget _buildContent(
      OrderDetailsState state, WidgetRef ref, BuildContext context) {
    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppPallete.primaryColor,
              strokeWidth: 3,
            ),
            SizedBox(height: ValuesManager.marginMedium),
            Text(
              'Loading order details...',
              style: TextStyle(
                color: AppPallete.lightGreyForText,
                fontSize: FontSize.s14,
              ),
            ),
          ],
        ),
      );
    }

    if (state.error != null) {
      return OrdersEmptyState(
        title: 'Error Occurred',
        message: state.error!,
        icon: Icons.error_outline_rounded,
        onRetry: () => ref.refresh(orderDetailsNotifierProvider(orderId)),
      );
    }

    if (state.order == null) {
      return OrdersEmptyState(
        title: 'Order Not Found',
        message: 'The requested order details could not be found.',
        icon: Icons.search_off_rounded,
        onRetry: () => ref.refresh(orderDetailsNotifierProvider(orderId)),
      );
    }

    final order = state.order!;
    return SingleChildScrollView(
      padding: EdgeInsets.all(ValuesManager.paddingMedium),
      child: Column(
        children: [
          OrderTimeline(currentStatus: order.status),
          SizedBox(height: ValuesManager.marginMedium),
          OrderSummary(order: order),
          SizedBox(height: ValuesManager.marginMedium),
          CustomerInfo(order: order),
          SizedBox(height: ValuesManager.marginMedium),
          ProductsList(items: order.items),
          SizedBox(height: ValuesManager.marginMedium),
          _buildQuickActions(context, order.id!, ref),
          SizedBox(height: ValuesManager.marginLarge),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
      BuildContext context, String orderId, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ValuesManager.paddingMedium),
      padding: EdgeInsets.all(ValuesManager.paddingMedium),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.s16,
              color: AppPallete.blackForText,
            ),
          ),
          SizedBox(height: ValuesManager.paddingMedium),
          // First row - 2 items
          Row(
            children: [
              Expanded(
                child: _buildCompactActionButton(
                  icon: Icons.edit,
                  label: 'Update Status',
                  color: AppPallete.primaryColor,
                  onTap: () => _showStatusChangeDialog(context, orderId, ref),
                ),
              ),
              SizedBox(width: ValuesManager.marginSmall),
              Expanded(
                child: _buildCompactActionButton(
                  icon: Icons.note_add,
                  label: 'Add Note',
                  color: AppPallete.blueColor,
                  onTap: () => _showNotesDialog(context, orderId, ref),
                  isOutlined: true,
                ),
              ),
            ],
          ),
          SizedBox(height: ValuesManager.marginSmall),
          // Second row - 2 items
          Row(
            children: [
              Expanded(
                child: _buildCompactActionButton(
                  icon: Icons.calendar_today,
                  label: 'Set Delivery',
                  color: AppPallete.orangeColor,
                  onTap: () => _showDeliveryDateDialog(context, orderId, ref),
                  isOutlined: true,
                ),
              ),
              SizedBox(width: ValuesManager.marginSmall),
              Expanded(
                child: _buildCompactActionButton(
                  icon: Icons.local_shipping,
                  label: 'Print Order',
                  color: AppPallete.greenColor,
                  onTap: () => _printDeliveryOrder(context, orderId),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isOutlined = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 8.w,
        ),
        decoration: BoxDecoration(
          color: isOutlined ? AppPallete.white : color,
          borderRadius: BorderRadius.circular(12.r),
          border: isOutlined ? Border.all(color: color, width: 1.5) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isOutlined ? color : AppPallete.white,
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isOutlined ? color : AppPallete.white,
                  fontSize: FontSize.s12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusChangeDialog(
      BuildContext context, String orderId, WidgetRef ref) {
    final statuses = [
      {
        'value': 'pending',
        'label': 'Pending',
        'color': AppPallete.pending,
        'icon': Icons.access_time_rounded,
      },
      {
        'value': 'processing',
        'label': 'Processing',
        'color': AppPallete.processing,
        'icon': Icons.build_rounded,
      },
      {
        'value': 'shipped',
        'label': 'Shipped',
        'color': AppPallete.shipped,
        'icon': Icons.local_shipping_rounded,
      },
      {
        'value': 'delivered',
        'label': 'Delivered',
        'color': AppPallete.delivered,
        'icon': Icons.check_circle_rounded,
      },
      {
        'value': 'cancelled',
        'label': 'Cancelled',
        'color': AppPallete.redColor,
        'icon': Icons.cancel_rounded,
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppPallete.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
          ),
          padding: EdgeInsets.all(ValuesManager.paddingLarge),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppPallete.borderColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: ValuesManager.paddingLarge),
                Text(
                  'Update Order Status',
                  style: TextStyle(
                    fontSize: FontSize.s20,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.blackForText,
                  ),
                ),
                SizedBox(height: ValuesManager.paddingLarge),
                ...statuses.map((status) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: ValuesManager.marginSmall),
                    child: ListTile(
                      onTap: () async {
                        Navigator.of(context).pop();

                        // Show loading snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16.w,
                                  height: 16.h,
                                  child: CircularProgressIndicator(
                                    color: AppPallete.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Text('Updating status...'),
                              ],
                            ),
                            backgroundColor: AppPallete.primaryColor,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        );

                        try {
                          await OrderStatusUpdater.updateStatus(
                              ref,
                              orderId,
                              status['value'] as String
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Order status updated successfully'),
                                backgroundColor: AppPallete.greenColor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: AppPallete.redColor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      leading: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: (status['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          status['icon'] as IconData,
                          color: status['color'] as Color,
                          size: 20.sp,
                        ),
                      ),
                      title: Text(
                        status['label'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: FontSize.s16,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNotesDialog(BuildContext context, String orderId, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Add Note',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.s18,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter your note here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppPallete.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppPallete.primaryColor, width: 2),
              ),
              contentPadding: EdgeInsets.all(ValuesManager.paddingMedium),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppPallete.lightGreyForText),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a note'),
                      backgroundColor: AppPallete.orangeColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop();

                // Show loading snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: CircularProgressIndicator(
                            color: AppPallete.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text('Saving note...'),
                      ],
                    ),
                    backgroundColor: AppPallete.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );

                try {
                  await OrderStatusUpdater.updateNotes(
                      ref,
                      orderId,
                      controller.text.trim()
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Note saved successfully'),
                        backgroundColor: AppPallete.greenColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: AppPallete.redColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeliveryDateDialog(
      BuildContext context, String orderId, WidgetRef ref) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppPallete.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        try {
          await OrderStatusUpdater.updateDeliveryDate(
              ref,
              orderId,
              date
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Delivery date updated successfully'),
                backgroundColor: AppPallete.greenColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: AppPallete.redColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
          }
        }
      }
    });
  }

  void _printInvoice(BuildContext context) {
    _generateAndPrintInvoice(context, 'invoice');
  }

  void _printDeliveryOrder(BuildContext context, String orderId) {
    _generateAndPrintInvoice(context, 'delivery', orderId: orderId);
  }

  void _shareInvoice(BuildContext context) {
    _generateAndPrintInvoice(context, 'share');
  }

  void _generateAndPrintInvoice(
      BuildContext context, String action, {
        String? orderId,
      }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              action == 'invoice'
                  ? 'Printing invoice...'
                  : action == 'delivery'
                  ? 'Printing delivery order...'
                  : 'Sharing invoice...'
          ),
          backgroundColor: AppPallete.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }
    print('Executing $action for order: $orderId');
  }
}