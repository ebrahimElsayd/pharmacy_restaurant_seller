import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../providers/orders_filter_notifier.dart';

class OrdersFilters extends ConsumerWidget {
  const OrdersFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(ordersFilterNotifierProvider);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ValuesManager.paddingMedium,
        vertical: ValuesManager.paddingSmall,
      ),
      decoration: const BoxDecoration(
        color: AppPallete.borderColor,
        border: Border(
          bottom: BorderSide(color: AppPallete.borderColor),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Filters:', // Translated
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppPallete.lightGreyForText,
            ),
          ),
          SizedBox(width: ValuesManager.marginMedium),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    value: null,
                    groupValue: filterState.status,
                  ),
                  SizedBox(width: ValuesManager.marginSmall),
                  _FilterChip(
                    label: 'Pending',
                    value: 'pending',
                    groupValue: filterState.status,
                  ),
                  SizedBox(width: ValuesManager.marginSmall),
                  _FilterChip(
                    label: 'Processing',
                    value: 'processing',
                    groupValue: filterState.status,
                  ),
                  SizedBox(width: ValuesManager.marginSmall),
                  _FilterChip(
                    label: 'Shipped',
                    value: 'shipped',
                    groupValue: filterState.status,
                  ),
                  SizedBox(width: ValuesManager.marginSmall),
                  _FilterChip(
                    label: 'Delivered',
                    value: 'delivered',
                    groupValue: filterState.status,
                  ),
                  SizedBox(width: ValuesManager.marginSmall),
                  _FilterChip(
                    label: 'Cancelled',
                    value: 'cancelled',
                    groupValue: filterState.status,
                  ),
                  SizedBox(width: ValuesManager.marginSmall),
                  _FilterChip(
                    label: 'Returned',
                    value: 'returned',
                    groupValue: filterState.status,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends ConsumerWidget {
  final String label;
  final String? value;
  final String? groupValue;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.groupValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isSelected = (value == null && groupValue == null) || (value == groupValue);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: FontSize.s12,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        final notifier = ref.read(ordersFilterNotifierProvider.notifier);

        notifier.setStatus(selected ? value : null);
      },
      selectedColor: AppPallete.primaryColor.withValues(alpha: 0.1),
      backgroundColor: AppPallete.white,
      checkmarkColor: AppPallete.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppPallete.primaryColor : AppPallete.lightGreyForText, // تأكد من الألوان
        fontSize: FontSize.s12,
      ),
      side: BorderSide(
        color: isSelected ? AppPallete.primaryColor : AppPallete.borderColor, // تأكد من الألوان
      ),
    );
  }
}