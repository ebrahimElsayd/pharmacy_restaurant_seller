// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'package:pharmacy_restaurant_seller/core/utils/try_and_catch.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// final supabaseClientProvider =
//     Provider.autoDispose<SupabaseClient>((ref) => Supabase.instance.client);
//
// final homeRemoteDataSourceProvider = Provider.autoDispose<HomeRemoteDataSource>(
//     (ref) =>
//         HomeRemoteDataSourceImpl(client: ref.watch(supabaseClientProvider)));
//
// abstract interface class HomeRemoteDataSource {
//   Future<List<Map<String, dynamic>>> getAllItems(int categoryId);
//   Future<List<Map<String, dynamic>>> getAllCategories();
//   Future<List<Map<String, dynamic>>> getRecommendedItems();
//   Future<List<Map<String, dynamic>>> getBestSellingItems();
//   Future<List<Map<String, dynamic>>> fetchItemsWithFavorites(
//       int userId, int categoryId);
//   Future<void> addToFavorites(int userId, String itemId);
//   Future<void> removeFromFavorites(int userId, String itemId);
//   Future<List<Map<String, dynamic>>> getUserFavorites(int userId);
//   Future<void> addItemToCart(String itemId, int userId);
//   Future<void> removeItemFromCart(String itemId, int userId);
// }
//
// class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
//   final SupabaseClient client;
//   HomeRemoteDataSourceImpl({required this.client});
//
//   @override
//   Future<List<Map<String, dynamic>>> getAllCategories() async {
//     return executeTryAndCatchForDataLayer(() async {
//       final categories = await client.from('categories').select('*');
//       return List<Map<String, dynamic>>.from(categories);
//     });
//   }
//
//   @override
//   Future<List<Map<String, dynamic>>> getAllItems(int categoryId) async {
//     return executeTryAndCatchForDataLayer(() async {
//       final items = await client
//           .from('items')
//           .select('*')
//           .eq('category_id', categoryId)
//           .limit(5);
//       return List<Map<String, dynamic>>.from(items);
//     });
//   }
//
//   @override
//   Future<List<Map<String, dynamic>>> getRecommendedItems() async {
//     return executeTryAndCatchForDataLayer(() async {
//       final items = await client
//           .from('items')
//           .select('*')
//           .order('created_at', ascending: false)
//           .limit(5);
//       return List<Map<String, dynamic>>.from(items);
//     });
//   }
//
//   @override
//   Future<List<Map<String, dynamic>>> getBestSellingItems() async {
//     return executeTryAndCatchForDataLayer(() async {
//       // Using random items for best selling (you can modify this based on your needs)
//       final items = await client.from('items').select('*').limit(5);
//       return List<Map<String, dynamic>>.from(items);
//     });
//   }
//
//   @override
//   Future<List<Map<String, dynamic>>> fetchItemsWithFavorites(
//       int userId, int categoryId) async {
//     return await client.rpc('fetch_items_with_favourites', params: {
//       'user_id_input': userId,
//       'category_id_input': categoryId,
//     });
//   }
//
//   @override
//   Future<void> addToFavorites(int userId, String itemId) async {
//     executeTryAndCatchForDataLayer(() async {
//       await client.from('favourite').insert({
//         'user_id': userId,
//         'item_id': itemId,
//       });
//     });
//   }
//
//   @override
//   Future<void> removeFromFavorites(int userId, String itemId) async {
//     executeTryAndCatchForDataLayer(() async {
//       await client
//           .from('favourite')
//           .delete()
//           .eq('user_id', userId)
//           .eq('item_id', itemId);
//     });
//   }
//
//   @override
//   Future<List<Map<String, dynamic>>> getUserFavorites(int userId) async {
//     return await client.rpc('fetch_favourite_items_for_specific_user',
//         params: {'user_id_input': userId});
//   }
//
//   @override
//   Future<void> addItemToCart(String itemId, int userId) async {
//     return executeTryAndCatchForDataLayer(() async {
//       return await client
//           .from("cart")
//           .insert({"item_id": itemId, "user_id": userId});
//     });
//   }
//
//   @override
//   Future<void> removeItemFromCart(String itemId, int userId) async {
//     return executeTryAndCatchForDataLayer(() async {
//       return await client
//           .from("cart")
//           .delete()
//           .eq("item_id", itemId)
//           .eq("user_id", userId);
//     });
//   }
// }
