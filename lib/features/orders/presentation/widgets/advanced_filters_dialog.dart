import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../providers/orders_filter_notifier.dart';

class AdvancedFiltersDialog extends ConsumerStatefulWidget {
  const AdvancedFiltersDialog({super.key});

  @override
  ConsumerState<AdvancedFiltersDialog> createState() => _AdvancedFiltersDialogState();
}

class _AdvancedFiltersDialogState extends ConsumerState<AdvancedFiltersDialog> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late String? _selectedStatus;
  late String _searchQuery;

  @override
  void initState() {
    super.initState();
    final filterState = ref.read(ordersFilterNotifierProvider);
    _startDate = filterState.startDate;
    _endDate = filterState.endDate;
    _selectedStatus = filterState.status;
    _searchQuery = filterState.searchQuery ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Advanced Filters',
        style: TextStyle(
          fontSize: FontSize.s18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 300.w,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusFilter(),
              SizedBox(height: ValuesManager.marginMedium),
              _buildDateRangeFilter(),
              SizedBox(height: ValuesManager.marginMedium),
              _buildSearchFilter(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final notifier = ref.read(ordersFilterNotifierProvider.notifier);
            notifier.clearFilters();
            Navigator.of(context).pop();
          },
          child: const Text('Clear All'),
        ),
        ElevatedButton(
          onPressed: _applyFilters,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.primaryColor,
          ),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    final statuses = [
      {'value': null, 'label': 'All Status'},
      {'value': 'pending', 'label': 'Pending'},
      {'value': 'processing', 'label': 'Processing'},
      {'value': 'shipped', 'label': 'Shipped'},
      {'value': 'delivered', 'label': 'Delivered'},
      {'value': 'cancelled', 'label': 'Cancelled'},
      {'value': 'returned', 'label': 'Returned'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Status',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: FontSize.s16,
          ),
        ),
        SizedBox(height: ValuesManager.marginSmall),
        Wrap(
          spacing: ValuesManager.marginSmall,
          runSpacing: ValuesManager.marginSmall,
          children: statuses.map((status) {
            return FilterChip(
              label: Text(
                status['label'] as String,
                style: TextStyle(fontSize: FontSize.s12),
              ),
              selected: _selectedStatus == status['value'],
              onSelected: (selected) {
                setState(() {
                  _selectedStatus = selected ? status['value'] : null;
                });
              },
              selectedColor: AppPallete.primaryColor.withValues(alpha: 0.1),
              backgroundColor: AppPallete.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date Range',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: FontSize.s16,
          ),
        ),
        SizedBox(height: ValuesManager.marginSmall),
        Row(
          children: [
            Expanded(
              child: _DateButton(
                label: _startDate != null
                    ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                    : 'From Date',
                onTap: () => _pickDate(true),
              ),
            ),
            SizedBox(width: ValuesManager.marginSmall),
            const Text('to'),
            SizedBox(width: ValuesManager.marginSmall),
            Expanded(
              child: _DateButton(
                label: _endDate != null
                    ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                    : 'To Date',
                onTap: () => _pickDate(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Search Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: FontSize.s16,
          ),
        ),
        SizedBox(height: ValuesManager.marginSmall),
        TextField(
          controller: TextEditingController(text: _searchQuery),
          decoration: InputDecoration(
            hintText: 'Search by order number or customer name',
            border: const OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ValuesManager.paddingMedium,
              vertical: ValuesManager.paddingMedium,
            ),
          ),
          onChanged: (value) => _searchQuery = value,
        ),
      ],
    );
  }

  Future<void> _pickDate(bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _applyFilters() {
    final notifier = ref.read(ordersFilterNotifierProvider.notifier);
    notifier.setStatus(_selectedStatus);
    notifier.setDateRange(_startDate, _endDate);
    notifier.setSearchQuery(_searchQuery.isEmpty ? null : _searchQuery);
    Navigator.of(context).pop();
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DateButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.white,
        foregroundColor: AppPallete.blackForText,
        side: BorderSide(color: AppPallete.borderColor),
        padding: EdgeInsets.symmetric(vertical: ValuesManager.paddingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
        ),
      ),
      child: Text(label),
    );
  }
}