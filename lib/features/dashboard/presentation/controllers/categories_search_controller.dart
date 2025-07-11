// import 'package:flutter/material.dart';
// import '../../../../core/comman/entitys/categories.dart';
//
// class CategoriesSearchController extends ChangeNotifier {
//   String _searchQuery = '';
//   List<Categories> _categories = [];
//   List<Categories> _filteredCategories = [];
//
//   String get searchQuery => _searchQuery;
//   List<Categories> get filteredCategories => _filteredCategories;
//
//   void setCategories(List<Categories> categories) {
//     _categories = categories;
//     _applySearch();
//   }
//
//   void updateSearchQuery(String query) {
//     _searchQuery = query;
//     _applySearch();
//     notifyListeners();
//   }
//
//   void _applySearch() {
//     if (_searchQuery.isEmpty) {
//       _filteredCategories = List.from(_categories);
//       return;
//     }
//
//     _filteredCategories = _categories.where((category) {
//       return category.name.toLowerCase().contains(_searchQuery.toLowerCase());
//     }).toList();
//   }
// }
