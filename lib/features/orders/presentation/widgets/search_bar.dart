import 'dart:async';
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
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    // Initialize search from provider if exists
    final filterState = ref.read(ordersFilterNotifierProvider);
    if (filterState.searchQuery != null) {
      _controller.text = filterState.searchQuery!;
    }

    // Add listener to focus node to track search focus
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isSearchFocused = _focusNode.hasFocus;
    });

    // If search loses focus and is not empty, trigger search
    if (!_focusNode.hasFocus) {
      _onSearchSubmit();
    }
  }

  void _onSearchChanged(String value) {
    // Cancel any previous debounce timer
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    final notifier = ref.read(ordersFilterNotifierProvider.notifier);

    // Update the search query in the provider
    notifier.setSearchQuery(value.isEmpty ? null : value);

    // Set a new timer for debounce (500ms delay)
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Only trigger search if text is not empty
      if (value.isNotEmpty) {
        ref.read(ordersNotifierProvider.notifier).filterOrders();
      } else {
        // If search is cleared, explicitly refresh with null search query
        ref.read(ordersNotifierProvider.notifier).clearSearchAndRefresh();
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    final notifier = ref.read(ordersFilterNotifierProvider.notifier);
    notifier.setSearchQuery(null);
    ref.read(ordersNotifierProvider.notifier).clearSearchAndRefresh();
    // Unfocus the search field
    _focusNode.unfocus();
  }

  void _onSearchSubmit() {
    // Unfocus the text field
    _focusNode.unfocus();

    // If search is empty but was previously not empty, ensure we reload all orders
    if (_controller.text.isEmpty) {
      ref.read(ordersNotifierProvider.notifier).clearSearchAndRefresh();
    } else {
      ref.read(ordersNotifierProvider.notifier).filterOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // If clicking on the search container but not the text field, focus the text field
        if (!_isSearchFocused) {
          _focusNode.requestFocus();
        }
      },
      child: Container(
        margin: EdgeInsets.all(ValuesManager.marginMedium),
        decoration: BoxDecoration(
          color: AppPallete.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search orders...', // Translated
            hintStyle: const TextStyle(color: AppPallete.lightGreyForText),
            prefixIcon: const Icon(
              Icons.search,
              color: AppPallete.lightGreyForText,
            ),
            // suffixIcon: _controller.text.isNotEmpty
            //     ? IconButton(
            //   icon: const Icon(
            //     Icons.clear,
            //     color: AppPallete.lightGreyForText,
            //   ),
            //   onPressed: _clearSearch,
            // )
            //     : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ValuesManager.paddingMedium,
              vertical: ValuesManager.paddingMedium,
            ),
          ),
          onChanged: _onSearchChanged,
          onSubmitted: (_) => _onSearchSubmit(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }
}