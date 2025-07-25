import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/values_manager.dart';
import '../providers/orders_filter_notifier.dart';
import '../providers/orders_notifier.dart';

class OrdersSearchBar extends ConsumerStatefulWidget {
  final VoidCallback onSearch;

  const OrdersSearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  ConsumerState<OrdersSearchBar> createState() => _OrdersSearchBarState();
}

class _OrdersSearchBarState extends ConsumerState<OrdersSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize search from provider if exists
    final filterState = ref.read(ordersFilterNotifierProvider);
    if (filterState.searchQuery != null) {
      _controller.text = filterState.searchQuery!;
    }
  }

  // Inside orders_search_bar.dart

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(ValuesManager.marginMedium),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search orders...', // Translated
          hintStyle: const TextStyle(color: AppPallete.lightGreyForText),
          prefixIcon: const Icon(
            Icons.search,
            color: AppPallete.lightGreyForText,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
            icon: const Icon(
              Icons.clear,
              color: AppPallete.lightGreyForText,
            ),
            onPressed: () {
              _controller.clear();
              final notifier = ref.read(ordersFilterNotifierProvider.notifier);
              notifier.setSearchQuery(null); // Clear search in provider
              // Trigger refresh via notifier (which now handles clearing correctly)
              ref.read(ordersNotifierProvider.notifier).filterOrders();
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ValuesManager.paddingMedium,
            vertical: ValuesManager.paddingMedium,
          ),
        ),
        onChanged: (value) {
          final notifier = ref.read(ordersFilterNotifierProvider.notifier);
          notifier.setSearchQuery(value.isEmpty ? null : value); // Update search in provider
          // Optionally debounce here if needed, or rely on onSubmitted
          // For immediate feedback, you might call filterOrders here, but be mindful of performance.
          // widget.onSearch(); // Removed direct call, let notifier handle it
        },
        onSubmitted: (_) {
          // Trigger refresh when user submits search (e.g., presses Enter)
          ref.read(ordersNotifierProvider.notifier).filterOrders();
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}