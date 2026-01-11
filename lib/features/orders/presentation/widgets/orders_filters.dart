import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../providers/orders_filter_notifier.dart';
import '../providers/orders_notifier.dart';

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
    // Properly determine if this chip is selected
    final isSelected = (value == null && groupValue == null) || (value == groupValue);

    // Choose appropriate colors based on the status value
    Color chipColor = AppPallete.primaryColor;
    if (value != null) {
      switch (value) {
        case 'pending':
          chipColor = AppPallete.pending;
          break;
        case 'processing':
          chipColor = AppPallete.processing;
          break;
        case 'shipped':
          chipColor = AppPallete.shipped;
          break;
        case 'delivered':
          chipColor = AppPallete.delivered;
          break;
        case 'cancelled':
          chipColor = AppPallete.redColor;
          break;
        case 'returned':
          chipColor = AppPallete.orangeColor;
          break;
        default:
          chipColor = AppPallete.primaryColor;
      }
    }

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: FontSize.s12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        // This is the fix for the filter issue:
        // Always set the status correctly even when clicking "All"
        final notifier = ref.read(ordersFilterNotifierProvider.notifier);

        // If clicking on "All" or deselecting current filter, explicitly clear filter
        if (value == null || !selected) {
          notifier.clearFilters(); // Use clearFilters to reset all filters
        } else {
          notifier.setStatus(value); // Set the selected filter
        }

        // Trigger a refresh of orders with the new filter state
        ref.read(ordersNotifierProvider.notifier).filterOrders();
      },
      selectedColor: isSelected ? chipColor.withOpacity(0.15) : AppPallete.white,
      backgroundColor: AppPallete.white,
      checkmarkColor: chipColor,
      labelStyle: TextStyle(
        color: isSelected ? chipColor : AppPallete.lightGreyForText,
        fontSize: FontSize.s12,
      ),
      side: BorderSide(
        color: isSelected ? chipColor : AppPallete.borderColor,
        width: isSelected ? 1.5 : 1.0,
      ),
      elevation: isSelected ? 1 : 0,
      shadowColor: isSelected ? chipColor.withOpacity(0.3) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}