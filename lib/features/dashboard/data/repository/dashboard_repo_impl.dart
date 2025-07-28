
import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/exception.dart';
import '../../domain/entitise/dashboard_stats.dart';
import '../../domain/entitise/order_chart_data.dart';
import '../../domain/entitise/top_product.dart';
import '../../domain/repo/dashboard_repo.dart';
import '../data_source/dashboard_remote_data_source.dart'; // ✅ استيراد Entity

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Exception, DashboardStats>> getDashboardStats() async {
    try {
      // ✅ الحصول على Model من Data Source
      final statsModel = await remoteDataSource.getDashboardStats();
      // ✅ تحويل Model إلى Entity قبل الإرجاع
      return Right(statsModel.toEntity());
    } on Exception catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<Exception, OrderChartData>> getOrdersChartData() async {
    try {
      // ✅ الحصول على Model من Data Source
      final chartDataModel = await remoteDataSource.getOrdersChartData();
      // ✅ تحويل Model إلى Entity قبل الإرجاع
      return Right(chartDataModel.toEntity());
    } on Exception catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<TopProduct>>> getTopProducts() async {
    try {
      // ✅ الحصول على Models من Data Source
      final productsModels = await remoteDataSource.getTopProducts();
      // ✅ تحويل Models إلى Entities قبل الإرجاع
      final products = productsModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } on Exception catch (e) {
      return Left(ServerException(e.toString()));
    }
  }
}