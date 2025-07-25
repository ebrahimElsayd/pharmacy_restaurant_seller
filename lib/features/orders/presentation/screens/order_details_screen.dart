// lib/feature/orders/presentation/screens/order_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../providers/order_details_notifier.dart';
import '../providers/order_details_state.dart';
import '../providers/usecases_providers.dart';
import '../widgets/customer_info.dart';
import '../widgets/order_summary.dart';
import '../widgets/order_timeline.dart';
import '../widgets/orders_empty_state.dart';
import '../widgets/products_list.dart';

// إضافة Provider لتحديث الحالة
final updateOrderStatusNotifierProvider =
StateNotifierProvider<UpdateOrderStatusNotifier, void>(
      (ref) => UpdateOrderStatusNotifier(ref),
);

class UpdateOrderStatusNotifier extends StateNotifier<void> {
  final Ref ref;

  UpdateOrderStatusNotifier(this.ref) : super(null);

  Future<void> updateStatus(String orderId, String status) async {
    final updateStatusUseCase = ref.read(updateOrderStatusProvider);
    final result = await updateStatusUseCase(orderId, status);
    return result.fold(
          (failure) => throw failure,
          (_) => null,
    );
  }

  Future<void> updateNotes(String orderId, String notes) async {
    final updateNotesUseCase = ref.read(updateOrderNotesProvider);
    final result = await updateNotesUseCase(orderId, notes);
    return result.fold(
          (failure) => throw failure,
          (_) => null,
    );
  }

  Future<void> updateDeliveryDate(String orderId, DateTime date) async {
    final updateDateUseCase = ref.read(updateExpectedDeliveryDateProvider);
    final result = await updateDateUseCase(orderId, date);
    return result.fold(
          (failure) => throw failure,
          (_) => null,
    );
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
      appBar: _buildAppBar(context),
      body: _buildContent(orderDetailsState, ref, context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'تفاصيل الطلب',
        style: TextStyle(
          fontSize: FontSize.s20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            // مشاركة الفاتورة
            _shareInvoice(context);
          },
          icon: const Icon(Icons.share),
        ),
        IconButton(
          onPressed: () {
            // طباعة الفاتورة
            _printInvoice(context);
          },
          icon: const Icon(Icons.print),
        ),
      ],
      backgroundColor: AppPallete.white,
      elevation: 0,
    );
  }

  /// ✅ الحل: استبدال state.when بالتحقق المباشر من خصائص الحالة
  Widget _buildContent(
      OrderDetailsState state, WidgetRef ref, BuildContext context) {
    // عرض مؤشر التحميل إذا كان التحميل جارٍ
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // عرض رسالة الخطأ إذا حدث خطأ
    if (state.error != null) {
      return OrdersEmptyState(
        title: 'حدث خطأ',
        message: state.error!,
        icon: Icons.error_outline,
        onRetry: () => ref.refresh(orderDetailsNotifierProvider(orderId)),
      );
    }

    // التحقق من وجود الطلب
    if (state.order == null) {
      return OrdersEmptyState(
        title: 'الطلب غير موجود',
        message: 'لم يتم العثور على تفاصيل الطلب المطلوب.',
        icon: Icons.info_outline,
        onRetry: () => ref.refresh(orderDetailsNotifierProvider(orderId)),
      );
    }

    // عرض تفاصيل الطلب إذا كان موجودًا
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
          _buildActionButtons(context, order.id!, ref),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, String orderId, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingMedium),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        border: Border.all(color: AppPallete.borderColor),
      ),
      child: Column(
        children: [
          const Text(
            'إجراءات سريعة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: ValuesManager.paddingMedium),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // تغيير حالة الطلب
                    _showStatusChangeDialog(context, orderId, ref);
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('تغيير الحالة'),
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(vertical: ValuesManager.paddingMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                    ),
                    backgroundColor: AppPallete.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: ValuesManager.marginSmall),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // إضافة ملاحظات
                    _showNotesDialog(context, orderId, ref);
                  },
                  icon: const Icon(Icons.note_add, size: 18),
                  label: const Text('إضافة ملاحظة'),
                  style: OutlinedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(vertical: ValuesManager.paddingMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ValuesManager.marginSmall),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // تعيين تاريخ التسليم
                    _showDeliveryDateDialog(context, orderId, ref);
                  },
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: const Text('تاريخ التسليم'),
                  style: OutlinedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(vertical: ValuesManager.paddingMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ValuesManager.marginSmall),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // طباعة طلب التوصيل
                    _printDeliveryOrder(context, orderId);
                  },
                  icon: const Icon(Icons.local_shipping, size: 18),
                  label: const Text('طلب التوصيل'),
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(vertical: ValuesManager.paddingMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                    ),
                    backgroundColor: AppPallete.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showStatusChangeDialog(
      BuildContext context, String orderId, WidgetRef ref) {
    final statuses = [
      {
        'value': 'pending',
        'label': 'قيد الانتظار',
        'color': AppPallete.orangeColor
      },
      {
        'value': 'processing',
        'label': 'قيد التجهيز',
        'color': AppPallete.blueColor
      },
      {'value': 'shipped', 'label': 'تم الشحن', 'color': AppPallete.primaryColor},
      {
        'value': 'delivered',
        'label': 'تم التوصيل',
        'color': AppPallete.greenColor
      },
      {'value': 'cancelled', 'label': 'ملغي', 'color': AppPallete.redColor},
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(ValuesManager.borderRadiusLarge)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(ValuesManager.paddingMedium),
                child: const Text(
                  'تغيير حالة الطلب',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...statuses.map((status) {
                return ListTile(
                  title: Text(status['label'] as String),
                  leading: Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: status['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    try {
                      await ref
                          .read(updateOrderStatusNotifierProvider.notifier)
                          .updateStatus(orderId, status['value'] as String);

                      // تحديث عرض الطلب
                      ref.invalidate(orderDetailsNotifierProvider(orderId));

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تحديث حالة الطلب بنجاح'),
                            backgroundColor: AppPallete.greenColor,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('حدث خطأ: ${e.toString()}'),
                            backgroundColor: AppPallete.redColor,
                          ),
                        );
                      }
                    }
                  },
                );
              }).toList(),
            ],
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
          title: const Text('إضافة ملاحظة'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'اكتب ملاحظتك هنا...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ref
                      .read(updateOrderStatusNotifierProvider.notifier)
                      .updateNotes(orderId, controller.text);

                  // تحديث عرض الطلب
                  ref.invalidate(orderDetailsNotifierProvider(orderId));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم حفظ الملاحظة بنجاح'),
                        backgroundColor: AppPallete.greenColor,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('حدث خطأ: ${e.toString()}'),
                        backgroundColor: AppPallete.redColor,
                      ),
                    );
                  }
                }
              },
              child: const Text('حفظ'),
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
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((date) async {
      if (date != null) {
        try {
          await ref
              .read(updateOrderStatusNotifierProvider.notifier)
              .updateDeliveryDate(orderId, date);

          // تحديث عرض الطلب
          ref.invalidate(orderDetailsNotifierProvider(orderId));

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تحديث تاريخ التسليم بنجاح'),
                backgroundColor: AppPallete.greenColor,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('حدث خطأ: ${e.toString()}'),
                backgroundColor: AppPallete.redColor,
              ),
            );
          }
        }
      }
    });
  }

  void _printInvoice(BuildContext context) {
    // طباعة الفاتورة
    _generateAndPrintInvoice(context, 'invoice');
  }

  void _printDeliveryOrder(BuildContext context, String orderId) {
    // طباعة طلب التوصيل
    _generateAndPrintInvoice(context, 'delivery', orderId: orderId);
  }

  void _shareInvoice(BuildContext context) {
    // مشاركة الفاتورة
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
                  ? 'جاري طباعة الفاتورة...'
                  : action == 'delivery'
                  ? 'جاري طباعة طلب التوصيل...'
                  : 'جاري مشاركة الفاتورة...'),
          backgroundColor: AppPallete.primaryColor,
        ),
      );
    }
    // هنا سيتم إضافة منطق الطباعة الفعلي
    print('تنفيذ $action للطلب: $orderId');
  }
}