// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:mktabte/features/home/data/data_source/auth_remote_data_source.dart';
//
// import '../../../../core/comman/entitys/categories.dart';
// import '../../../../core/erorr/failure.dart';
// import '../../../../core/utils/try_and_catch.dart';
// import '../../../admin/data/model/item_model.dart';
//
// final homeRepositoryProvider = Provider.autoDispose<HomeRepository>((ref) =>
//     HomeRepository(remoteDataSource: ref.watch(homeRemoteDataSourceProvider)));
//
// class HomeRepository {
//   HomeRemoteDataSource remoteDataSource;
//   HomeRepository({required this.remoteDataSource});
//
//   Future<Either<Failure, List<ItemModel>>> getRecommendedItems() async {
//     return executeTryAndCatchForRepository(() async {
//       final items = await remoteDataSource.getRecommendedItems();
//       return items.map((item) => ItemModel.fromMap(item)).toList();
//     });
//   }
//
//   Future<Either<Failure, List<ItemModel>>> getBestSellingItems() async {
//     return executeTryAndCatchForRepository(() async {
//       final items = await remoteDataSource.getBestSellingItems();
//       return items.map((item) => ItemModel.fromMap(item)).toList();
//     });
//   }
//
//   Future<Either<Failure, List<ItemModel>>> getAllItems(int categoryId) async {
//     return executeTryAndCatchForRepository(() async {
//       final items = await remoteDataSource.getAllItems(categoryId);
//       return items.map((item) => ItemModel.fromMap(item)).toList();
//     });
//   }
//
//   Future<Either<Failure, List<Categories>>> getAllCategories() async {
//     return executeTryAndCatchForRepository(() async {
//       final categories = await remoteDataSource.getAllCategories();
//       return categories
//           .map((category) => Categories.fromMap(category))
//           .toList();
//     });
//   }
//
//   Future<Either<Failure, List<ItemModel>>> fetchItemsWithFavorites(
//       int userId, int categoryId) async {
//     return executeTryAndCatchForRepository(() async {
//       final items =
//           await remoteDataSource.fetchItemsWithFavorites(userId, categoryId);
//       return items.map((item) => ItemModel.fromMap(item)).toList();
//     });
//   }
//
//   Future<Either<Failure, void>> addToFavorites(
//       int userId, String itemId) async {
//     return executeTryAndCatchForRepository(() async {
//       await remoteDataSource.addToFavorites(userId, itemId);
//     });
//   }
//
//   Future<Either<Failure, void>> removeFromFavorites(
//       int userId, String itemId) async {
//     return executeTryAndCatchForRepository(() async {
//       await remoteDataSource.removeFromFavorites(userId, itemId);
//     });
//   }
//
//   Future<Either<Failure, List<ItemModel>>> getUserFavorites(int userId) async {
//     return executeTryAndCatchForRepository(() async {
//       final items = await remoteDataSource.getUserFavorites(userId);
//       return items.map((item) => ItemModel.fromMap(item)).toList();
//     });
//   }
//
//   Future<Either<Failure, void>> addItemToCart(String itemId, int userId) async {
//     return executeTryAndCatchForRepository(() async {
//       await remoteDataSource.addItemToCart(itemId, userId);
//     });
//   }
//
//   Future<Either<Failure, void>> removeItemFromCart(
//       String itemId, int userId) async {
//     return executeTryAndCatchForRepository(() async {
//       await remoteDataSource.removeItemFromCart(itemId, userId);
//     });
//   }
// }
