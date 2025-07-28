import 'package:fpdart/fpdart.dart';

import '../entitise/order_chart_data.dart';
import '../repo/dashboard_repo.dart';

class GetOrdersChartData {
  final DashboardRepository repository;

  GetOrdersChartData(this.repository);

  Future<Either<Exception, OrderChartData>> call() async {
    try {
      final Either<Exception, OrderChartData> data = await repository.getOrdersChartData();
      return data;
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
